
DICTS=mmcif_ddl
TARGET=

all:
	@for dict in $(DICTS); do \
		echo "Building $$dict"; \
		./scripts/Build.sh $$dict $(TARGET) ;\
	 done
