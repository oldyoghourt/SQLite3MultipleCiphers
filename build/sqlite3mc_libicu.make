# Alternative GNU Make project makefile autogenerated by Premake

ifndef config
  config=debug_win32
endif

ifndef verbose
  SILENT = @
endif

.PHONY: clean prebuild

SHELLTYPE := posix
ifeq (.exe,$(findstring .exe,$(ComSpec)))
	SHELLTYPE := msdos
endif

# Configurations
# #############################################

RESCOMP = windres
INCLUDES += -I"$(LIBICU_PATH)/include"
FORCE_INCLUDE +=
ALL_CPPFLAGS += $(CPPFLAGS) -MMD -MP $(DEFINES) $(INCLUDES)
ALL_RESFLAGS += $(RESFLAGS) $(DEFINES) $(INCLUDES)
LIBS +=
LDDEPS +=
LINKCMD = $(AR) -rcs "$@" $(OBJECTS)
include config.gcc

define PREBUILDCMDS
endef
define PRELINKCMDS
endef
define POSTBUILDCMDS
endef

ifeq ($(config),debug_win32)
TARGETDIR = ../bin/gcc/lib/debug
TARGET = $(TARGETDIR)/sqlite3mc_icu.lib
OBJDIR = obj/gcc/Win32/Debug/sqlite3mc_libicu
DEFINES += -D_WINDOWS -DWIN32 -D_CRT_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -DDEBUG -D_DEBUG -D_LIB -DCODEC_TYPE=$(CODEC_TYPE) -DSQLITE_ENABLE_DEBUG=$(SQLITE_ENABLE_DEBUG) -DSQLITE_THREADSAFE=1 -DSQLITE_ENABLE_ICU=1 -DSQLITE_DQS=0 -DSQLITE_MAX_ATTACHED=10 -DSQLITE_ENABLE_EXPLAIN_COMMENTS=1 -DSQLITE_SOUNDEX=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_DESERIALIZE=1 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_FTS5=1 -DSQLITE_ENABLE_RTREE=1 -DSQLITE_ENABLE_GEOPOLY=1 -DSQLITE_CORE=1 -DSQLITE_ENABLE_EXTFUNC=1 -DSQLITE_ENABLE_MATH_FUNCTIONS=1 -DSQLITE_ENABLE_CSV=1 -DSQLITE_ENABLE_VSV=1 -DSQLITE_ENABLE_CARRAY=1 -DSQLITE_ENABLE_UUID=1 -DSQLITE_TEMP_STORE=2 -DSQLITE_USE_URI=1 -DSQLITE_USER_AUTHENTICATION=1 -DSQLITE_ENABLE_DBPAGE_VTAB=1 -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_STMTVTAB=1 -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION=1
ALL_CFLAGS += $(CFLAGS) $(ALL_CPPFLAGS) -m32 -g -msse4.2 -maes
ALL_CXXFLAGS += $(CXXFLAGS) $(ALL_CPPFLAGS) -m32 -g -msse4.2 -maes
ALL_LDFLAGS += $(LDFLAGS) -L/usr/lib32 -m32

else ifeq ($(config),debug_win64)
TARGETDIR = ../bin/gcc/lib/debug
TARGET = $(TARGETDIR)/sqlite3mc_icu_x64.lib
OBJDIR = obj/gcc/Win64/Debug/sqlite3mc_libicu
DEFINES += -D_WINDOWS -DWIN32 -D_CRT_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -DDEBUG -D_DEBUG -D_LIB -DCODEC_TYPE=$(CODEC_TYPE) -DSQLITE_ENABLE_DEBUG=$(SQLITE_ENABLE_DEBUG) -DSQLITE_THREADSAFE=1 -DSQLITE_ENABLE_ICU=1 -DSQLITE_DQS=0 -DSQLITE_MAX_ATTACHED=10 -DSQLITE_ENABLE_EXPLAIN_COMMENTS=1 -DSQLITE_SOUNDEX=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_DESERIALIZE=1 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_FTS5=1 -DSQLITE_ENABLE_RTREE=1 -DSQLITE_ENABLE_GEOPOLY=1 -DSQLITE_CORE=1 -DSQLITE_ENABLE_EXTFUNC=1 -DSQLITE_ENABLE_MATH_FUNCTIONS=1 -DSQLITE_ENABLE_CSV=1 -DSQLITE_ENABLE_VSV=1 -DSQLITE_ENABLE_CARRAY=1 -DSQLITE_ENABLE_UUID=1 -DSQLITE_TEMP_STORE=2 -DSQLITE_USE_URI=1 -DSQLITE_USER_AUTHENTICATION=1 -DSQLITE_ENABLE_DBPAGE_VTAB=1 -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_STMTVTAB=1 -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION=1
ALL_CFLAGS += $(CFLAGS) $(ALL_CPPFLAGS) -m64 -g -msse4.2 -maes
ALL_CXXFLAGS += $(CXXFLAGS) $(ALL_CPPFLAGS) -m64 -g -msse4.2 -maes
ALL_LDFLAGS += $(LDFLAGS) -L/usr/lib64 -m64

else ifeq ($(config),release_win32)
TARGETDIR = ../bin/gcc/lib/release
TARGET = $(TARGETDIR)/sqlite3mc_icu.lib
OBJDIR = obj/gcc/Win32/Release/sqlite3mc_libicu
DEFINES += -D_WINDOWS -DWIN32 -D_CRT_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -DNDEBUG -D_LIB -DCODEC_TYPE=$(CODEC_TYPE) -DSQLITE_ENABLE_DEBUG=$(SQLITE_ENABLE_DEBUG) -DSQLITE_THREADSAFE=1 -DSQLITE_ENABLE_ICU=1 -DSQLITE_DQS=0 -DSQLITE_MAX_ATTACHED=10 -DSQLITE_ENABLE_EXPLAIN_COMMENTS=1 -DSQLITE_SOUNDEX=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_DESERIALIZE=1 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_FTS5=1 -DSQLITE_ENABLE_RTREE=1 -DSQLITE_ENABLE_GEOPOLY=1 -DSQLITE_CORE=1 -DSQLITE_ENABLE_EXTFUNC=1 -DSQLITE_ENABLE_MATH_FUNCTIONS=1 -DSQLITE_ENABLE_CSV=1 -DSQLITE_ENABLE_VSV=1 -DSQLITE_ENABLE_CARRAY=1 -DSQLITE_ENABLE_UUID=1 -DSQLITE_TEMP_STORE=2 -DSQLITE_USE_URI=1 -DSQLITE_USER_AUTHENTICATION=1 -DSQLITE_ENABLE_DBPAGE_VTAB=1 -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_STMTVTAB=1 -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION=1
ALL_CFLAGS += $(CFLAGS) $(ALL_CPPFLAGS) -m32 -O2 -msse4.2 -maes
ALL_CXXFLAGS += $(CXXFLAGS) $(ALL_CPPFLAGS) -m32 -O2 -msse4.2 -maes
ALL_LDFLAGS += $(LDFLAGS) -L/usr/lib32 -m32 -s

else ifeq ($(config),release_win64)
TARGETDIR = ../bin/gcc/lib/release
TARGET = $(TARGETDIR)/sqlite3mc_icu_x64.lib
OBJDIR = obj/gcc/Win64/Release/sqlite3mc_libicu
DEFINES += -D_WINDOWS -DWIN32 -D_CRT_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -DNDEBUG -D_LIB -DCODEC_TYPE=$(CODEC_TYPE) -DSQLITE_ENABLE_DEBUG=$(SQLITE_ENABLE_DEBUG) -DSQLITE_THREADSAFE=1 -DSQLITE_ENABLE_ICU=1 -DSQLITE_DQS=0 -DSQLITE_MAX_ATTACHED=10 -DSQLITE_ENABLE_EXPLAIN_COMMENTS=1 -DSQLITE_SOUNDEX=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_DESERIALIZE=1 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_FTS5=1 -DSQLITE_ENABLE_RTREE=1 -DSQLITE_ENABLE_GEOPOLY=1 -DSQLITE_CORE=1 -DSQLITE_ENABLE_EXTFUNC=1 -DSQLITE_ENABLE_MATH_FUNCTIONS=1 -DSQLITE_ENABLE_CSV=1 -DSQLITE_ENABLE_VSV=1 -DSQLITE_ENABLE_CARRAY=1 -DSQLITE_ENABLE_UUID=1 -DSQLITE_TEMP_STORE=2 -DSQLITE_USE_URI=1 -DSQLITE_USER_AUTHENTICATION=1 -DSQLITE_ENABLE_DBPAGE_VTAB=1 -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_STMTVTAB=1 -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION=1
ALL_CFLAGS += $(CFLAGS) $(ALL_CPPFLAGS) -m64 -O2 -msse4.2 -maes
ALL_CXXFLAGS += $(CXXFLAGS) $(ALL_CPPFLAGS) -m64 -O2 -msse4.2 -maes
ALL_LDFLAGS += $(LDFLAGS) -L/usr/lib64 -m64 -s

endif

# Per File Configurations
# #############################################


# File sets
# #############################################

GENERATED :=
OBJECTS :=

GENERATED += $(OBJDIR)/sqlite3mc.o
OBJECTS += $(OBJDIR)/sqlite3mc.o

# Rules
# #############################################

all: $(TARGET)
	@:

$(TARGET): $(GENERATED) $(OBJECTS) $(LDDEPS) | $(TARGETDIR)
	$(PRELINKCMDS)
	@echo Linking sqlite3mc_libicu
	$(SILENT) $(LINKCMD)
	$(POSTBUILDCMDS)

$(TARGETDIR):
	@echo Creating $(TARGETDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) mkdir -p $(TARGETDIR)
else
	$(SILENT) mkdir $(subst /,\\,$(TARGETDIR))
endif

$(OBJDIR):
	@echo Creating $(OBJDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) mkdir -p $(OBJDIR)
else
	$(SILENT) mkdir $(subst /,\\,$(OBJDIR))
endif

clean:
	@echo Cleaning sqlite3mc_libicu
ifeq (posix,$(SHELLTYPE))
	$(SILENT) rm -f  $(TARGET)
	$(SILENT) rm -rf $(GENERATED)
	$(SILENT) rm -rf $(OBJDIR)
else
	$(SILENT) if exist $(subst /,\\,$(TARGET)) del $(subst /,\\,$(TARGET))
	$(SILENT) if exist $(subst /,\\,$(GENERATED)) rmdir /s /q $(subst /,\\,$(GENERATED))
	$(SILENT) if exist $(subst /,\\,$(OBJDIR)) rmdir /s /q $(subst /,\\,$(OBJDIR))
endif

prebuild: | $(OBJDIR)
	$(PREBUILDCMDS)

ifneq (,$(PCH))
$(OBJECTS): $(GCH) | $(PCH_PLACEHOLDER)
$(GCH): $(PCH) | prebuild
	@echo $(notdir $<)
	$(SILENT) $(CXX) -x c++-header $(ALL_CXXFLAGS) -o "$@" -MF "$(@:%.gch=%.d)" -c "$<"
$(PCH_PLACEHOLDER): $(GCH) | $(OBJDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) touch "$@"
else
	$(SILENT) echo $null >> "$@"
endif
else
$(OBJECTS): | prebuild
endif


# File Rules
# #############################################

$(OBJDIR)/sqlite3mc.o: ../src/sqlite3mc.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(ALL_CFLAGS) $(FORCE_INCLUDE) -o "$@" -MF "$(@:%.o=%.d)" -c "$<"

-include $(OBJECTS:%.o=%.d)
ifneq (,$(PCH))
  -include $(PCH_PLACEHOLDER).d
endif