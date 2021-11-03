include common_include.mk

# Primary test name
TEST = afu

# Build directory
OBJDIR = obj
CFLAGS += -I./$(OBJDIR)
CPPFLAGS += -I./$(OBJDIR)

LDFLAGS += -lopae-cxx-core

# Files and folders
SRCS = main.cpp AFU.cpp
OBJS = $(addprefix $(OBJDIR)/,$(patsubst %.cpp,%.o,$(SRCS)))

# Targets
all: $(TEST) $(TEST)_ase

# AFU info from JSON file, including AFU UUID
AFU_JSON_INFO = $(OBJDIR)/afu_json_info.h
$(AFU_JSON_INFO): ../hw/$(TEST).json | objdir
	afu_json_mgr json-info --afu-json=$^ --c-hdr=$@
$(OBJS): $(AFU_JSON_INFO)

$(TEST): $(OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS) $(FPGA_LIBS)

$(TEST)_ase: $(OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS) $(ASE_LIBS)

$(OBJDIR)/%.o: %.cpp | objdir
	$(CXX) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(TEST) $(TEST)_ase $(OBJDIR)

objdir:
	@mkdir -p $(OBJDIR)

.PHONY: all clean
