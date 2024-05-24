/*
** 2020-11-14
**
** The author disclaims copyright to this source code.  In place of
** a legal notice, here is a blessing:
**
**    May you do good and not evil.
**    May you find forgiveness for yourself and forgive others.
**    May you share freely, never taking more than you give.
**
************************************************************************
**
** This file contains an adjusted version of function sqlite3RunVacuum
** to allow reducing or removing reserved page space.
** For this purpose the number of reserved bytes per page for the target
** database is passed as an extra parameter to the adjusted function.
**
** NOTE: When upgrading to a new version of SQLite3 it is strongly
** recommended to check the original function sqlite3RunVacuum of the
** new version for relevant changes, and to incorporate them in the
** adjusted function below.
**
** Change 0: Rename function to sqlite3mcRunVacuumForRekey()
** Change 1: Add parameter 'int nRes'
** Change 2: Remove local variable 'int nRes'
** Change 3: Remove initialization 'nRes = sqlite3BtreeGetOptimalReserve(pMain)'
** Change 4: Call sqlite3mcBtreeSetPageSize instead of sqlite3BtreeSetPageSize for main database
**           (sqlite3mcBtreeSetPageSize allows to reduce the number of reserved bytes)
**
** This code is generated by the script rekeyvacuum.sh from SQLite version 3.46.0 amalgamation.
*/
SQLITE_PRIVATE SQLITE_NOINLINE int sqlite3mcRunVacuumForRekey(
  char **pzErrMsg,        /* Write error message here */
  sqlite3 *db,            /* Database connection */
  int iDb,                /* Which attached DB to vacuum */
  sqlite3_value *pOut     /* Write results here, if not NULL. VACUUM INTO */
, int nRes){
  int rc = SQLITE_OK;     /* Return code from service routines */
  Btree *pMain;           /* The database being vacuumed */
  Btree *pTemp;           /* The temporary database we vacuum into */
  u32 saved_mDbFlags;     /* Saved value of db->mDbFlags */
  u64 saved_flags;        /* Saved value of db->flags */
  i64 saved_nChange;      /* Saved value of db->nChange */
  i64 saved_nTotalChange; /* Saved value of db->nTotalChange */
  u32 saved_openFlags;    /* Saved value of db->openFlags */
  u8 saved_mTrace;        /* Saved trace settings */
  Db *pDb = 0;            /* Database to detach at end of vacuum */
  int isMemDb;            /* True if vacuuming a :memory: database */
  int nDb;                /* Number of attached databases */
  const char *zDbMain;    /* Schema name of database to vacuum */
  const char *zOut;       /* Name of output file */
  u32 pgflags = PAGER_SYNCHRONOUS_OFF; /* sync flags for output db */

  if( !db->autoCommit ){
    sqlite3SetString(pzErrMsg, db, "cannot VACUUM from within a transaction");
    return SQLITE_ERROR; /* IMP: R-12218-18073 */
  }
  if( db->nVdbeActive>1 ){
    sqlite3SetString(pzErrMsg, db,"cannot VACUUM - SQL statements in progress");
    return SQLITE_ERROR; /* IMP: R-15610-35227 */
  }
  saved_openFlags = db->openFlags;
  if( pOut ){
    if( sqlite3_value_type(pOut)!=SQLITE_TEXT ){
      sqlite3SetString(pzErrMsg, db, "non-text filename");
      return SQLITE_ERROR;
    }
    zOut = (const char*)sqlite3_value_text(pOut);
    db->openFlags &= ~SQLITE_OPEN_READONLY;
    db->openFlags |= SQLITE_OPEN_CREATE|SQLITE_OPEN_READWRITE;
  }else{
    zOut = "";
  }

  /* Save the current value of the database flags so that it can be
  ** restored before returning. Then set the writable-schema flag, and
  ** disable CHECK and foreign key constraints.  */
  saved_flags = db->flags;
  saved_mDbFlags = db->mDbFlags;
  saved_nChange = db->nChange;
  saved_nTotalChange = db->nTotalChange;
  saved_mTrace = db->mTrace;
  db->flags |= SQLITE_WriteSchema | SQLITE_IgnoreChecks;
  db->mDbFlags |= DBFLAG_PreferBuiltin | DBFLAG_Vacuum;
  db->flags &= ~(u64)(SQLITE_ForeignKeys | SQLITE_ReverseOrder
                   | SQLITE_Defensive | SQLITE_CountRows);
  db->mTrace = 0;

  zDbMain = db->aDb[iDb].zDbSName;
  pMain = db->aDb[iDb].pBt;
  isMemDb = sqlite3PagerIsMemdb(sqlite3BtreePager(pMain));

  /* Attach the temporary database as 'vacuum_db'. The synchronous pragma
  ** can be set to 'off' for this file, as it is not recovered if a crash
  ** occurs anyway. The integrity of the database is maintained by a
  ** (possibly synchronous) transaction opened on the main database before
  ** sqlite3BtreeCopyFile() is called.
  **
  ** An optimization would be to use a non-journaled pager.
  ** (Later:) I tried setting "PRAGMA vacuum_db.journal_mode=OFF" but
  ** that actually made the VACUUM run slower.  Very little journalling
  ** actually occurs when doing a vacuum since the vacuum_db is initially
  ** empty.  Only the journal header is written.  Apparently it takes more
  ** time to parse and run the PRAGMA to turn journalling off than it does
  ** to write the journal header file.
  */
  nDb = db->nDb;
  rc = execSqlF(db, pzErrMsg, "ATTACH %Q AS vacuum_db", zOut);
  db->openFlags = saved_openFlags;
  if( rc!=SQLITE_OK ) goto end_of_vacuum;
  assert( (db->nDb-1)==nDb );
  pDb = &db->aDb[nDb];
  assert( strcmp(pDb->zDbSName,"vacuum_db")==0 );
  pTemp = pDb->pBt;
  if( pOut ){
    sqlite3_file *id = sqlite3PagerFile(sqlite3BtreePager(pTemp));
    i64 sz = 0;
    if( id->pMethods!=0 && (sqlite3OsFileSize(id, &sz)!=SQLITE_OK || sz>0) ){
      rc = SQLITE_ERROR;
      sqlite3SetString(pzErrMsg, db, "output file already exists");
      goto end_of_vacuum;
    }
    db->mDbFlags |= DBFLAG_VacuumInto;

    /* For a VACUUM INTO, the pager-flags are set to the same values as
    ** they are for the database being vacuumed, except that PAGER_CACHESPILL
    ** is always set. */
    pgflags = db->aDb[iDb].safety_level | (db->flags & PAGER_FLAGS_MASK);
  }

  /* A VACUUM cannot change the pagesize of an encrypted database. */
  if( db->nextPagesize ){
    extern void sqlite3mcCodecGetKey(sqlite3*, int, void**, int*);
    int nKey;
    char *zKey;
    sqlite3mcCodecGetKey(db, iDb, (void**)&zKey, &nKey);
    if( nKey ) db->nextPagesize = 0;
  }

  sqlite3BtreeSetCacheSize(pTemp, db->aDb[iDb].pSchema->cache_size);
  sqlite3BtreeSetSpillSize(pTemp, sqlite3BtreeSetSpillSize(pMain,0));
  sqlite3BtreeSetPagerFlags(pTemp, pgflags|PAGER_CACHESPILL);

  /* Begin a transaction and take an exclusive lock on the main database
  ** file. This is done before the sqlite3BtreeGetPageSize(pMain) call below,
  ** to ensure that we do not try to change the page-size on a WAL database.
  */
  rc = execSql(db, pzErrMsg, "BEGIN");
  if( rc!=SQLITE_OK ) goto end_of_vacuum;
  rc = sqlite3BtreeBeginTrans(pMain, pOut==0 ? 2 : 0, 0);
  if( rc!=SQLITE_OK ) goto end_of_vacuum;

  /* Do not attempt to change the page size for a WAL database */
  if( sqlite3PagerGetJournalMode(sqlite3BtreePager(pMain))
                                               ==PAGER_JOURNALMODE_WAL
   && pOut==0
  ){
    db->nextPagesize = 0;
  }

  if( sqlite3BtreeSetPageSize(pTemp, sqlite3BtreeGetPageSize(pMain), nRes, 0)
   || (!isMemDb && sqlite3BtreeSetPageSize(pTemp, db->nextPagesize, nRes, 0))
   || NEVER(db->mallocFailed)
  ){
    rc = SQLITE_NOMEM_BKPT;
    goto end_of_vacuum;
  }

#ifndef SQLITE_OMIT_AUTOVACUUM
  sqlite3BtreeSetAutoVacuum(pTemp, db->nextAutovac>=0 ? db->nextAutovac :
                                           sqlite3BtreeGetAutoVacuum(pMain));
#endif

  /* Query the schema of the main database. Create a mirror schema
  ** in the temporary database.
  */
  db->init.iDb = nDb; /* force new CREATE statements into vacuum_db */
  rc = execSqlF(db, pzErrMsg,
      "SELECT sql FROM \"%w\".sqlite_schema"
      " WHERE type='table'AND name<>'sqlite_sequence'"
      " AND coalesce(rootpage,1)>0",
      zDbMain
  );
  if( rc!=SQLITE_OK ) goto end_of_vacuum;
  rc = execSqlF(db, pzErrMsg,
      "SELECT sql FROM \"%w\".sqlite_schema"
      " WHERE type='index'",
      zDbMain
  );
  if( rc!=SQLITE_OK ) goto end_of_vacuum;
  db->init.iDb = 0;

  /* Loop through the tables in the main database. For each, do
  ** an "INSERT INTO vacuum_db.xxx SELECT * FROM main.xxx;" to copy
  ** the contents to the temporary database.
  */
  rc = execSqlF(db, pzErrMsg,
      "SELECT'INSERT INTO vacuum_db.'||quote(name)"
      "||' SELECT*FROM\"%w\".'||quote(name)"
      "FROM vacuum_db.sqlite_schema "
      "WHERE type='table'AND coalesce(rootpage,1)>0",
      zDbMain
  );
  assert( (db->mDbFlags & DBFLAG_Vacuum)!=0 );
  db->mDbFlags &= ~DBFLAG_Vacuum;
  if( rc!=SQLITE_OK ) goto end_of_vacuum;

  /* Copy the triggers, views, and virtual tables from the main database
  ** over to the temporary database.  None of these objects has any
  ** associated storage, so all we have to do is copy their entries
  ** from the schema table.
  */
  rc = execSqlF(db, pzErrMsg,
      "INSERT INTO vacuum_db.sqlite_schema"
      " SELECT*FROM \"%w\".sqlite_schema"
      " WHERE type IN('view','trigger')"
      " OR(type='table'AND rootpage=0)",
      zDbMain
  );
  if( rc ) goto end_of_vacuum;

  /* At this point, there is a write transaction open on both the
  ** vacuum database and the main database. Assuming no error occurs,
  ** both transactions are closed by this block - the main database
  ** transaction by sqlite3BtreeCopyFile() and the other by an explicit
  ** call to sqlite3BtreeCommit().
  */
  {
    u32 meta;
    int i;

    /* This array determines which meta meta values are preserved in the
    ** vacuum.  Even entries are the meta value number and odd entries
    ** are an increment to apply to the meta value after the vacuum.
    ** The increment is used to increase the schema cookie so that other
    ** connections to the same database will know to reread the schema.
    */
    static const unsigned char aCopy[] = {
       BTREE_SCHEMA_VERSION,     1,  /* Add one to the old schema cookie */
       BTREE_DEFAULT_CACHE_SIZE, 0,  /* Preserve the default page cache size */
       BTREE_TEXT_ENCODING,      0,  /* Preserve the text encoding */
       BTREE_USER_VERSION,       0,  /* Preserve the user version */
       BTREE_APPLICATION_ID,     0,  /* Preserve the application id */
    };

    assert( SQLITE_TXN_WRITE==sqlite3BtreeTxnState(pTemp) );
    assert( pOut!=0 || SQLITE_TXN_WRITE==sqlite3BtreeTxnState(pMain) );

    /* Copy Btree meta values */
    for(i=0; i<ArraySize(aCopy); i+=2){
      /* GetMeta() and UpdateMeta() cannot fail in this context because
      ** we already have page 1 loaded into cache and marked dirty. */
      sqlite3BtreeGetMeta(pMain, aCopy[i], &meta);
      rc = sqlite3BtreeUpdateMeta(pTemp, aCopy[i], meta+aCopy[i+1]);
      if( NEVER(rc!=SQLITE_OK) ) goto end_of_vacuum;
    }

    if( pOut==0 ){
      rc = sqlite3BtreeCopyFile(pMain, pTemp);
    }
    if( rc!=SQLITE_OK ) goto end_of_vacuum;
    rc = sqlite3BtreeCommit(pTemp);
    if( rc!=SQLITE_OK ) goto end_of_vacuum;
#ifndef SQLITE_OMIT_AUTOVACUUM
    if( pOut==0 ){
      sqlite3BtreeSetAutoVacuum(pMain, sqlite3BtreeGetAutoVacuum(pTemp));
    }
#endif
  }

  assert( rc==SQLITE_OK );
  if( pOut==0 ){
    rc = sqlite3mcBtreeSetPageSize(pMain, sqlite3BtreeGetPageSize(pTemp), nRes,1);
  }

end_of_vacuum:
  /* Restore the original value of db->flags */
  db->init.iDb = 0;
  db->mDbFlags = saved_mDbFlags;
  db->flags = saved_flags;
  db->nChange = saved_nChange;
  db->nTotalChange = saved_nTotalChange;
  db->mTrace = saved_mTrace;
  sqlite3BtreeSetPageSize(pMain, -1, 0, 1);

  /* Currently there is an SQL level transaction open on the vacuum
  ** database. No locks are held on any other files (since the main file
  ** was committed at the btree level). So it safe to end the transaction
  ** by manually setting the autoCommit flag to true and detaching the
  ** vacuum database. The vacuum_db journal file is deleted when the pager
  ** is closed by the DETACH.
  */
  db->autoCommit = 1;

  if( pDb ){
    sqlite3BtreeClose(pDb->pBt);
    pDb->pBt = 0;
    pDb->pSchema = 0;
  }

  /* This both clears the schemas and reduces the size of the db->aDb[]
  ** array. */
  sqlite3ResetAllSchemasOfConnection(db);

  return rc;
}
