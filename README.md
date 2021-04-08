# PDBx/mmCIF DDL2 Dictionary

[![CI](https://github.com/wwpdb-dictionaries/mmcif_ddl/actions/workflows/main.yml/badge.svg)](https://github.com/wwpdb-dictionaries/mmcif_ddl/actions/workflows/main.yml)

This repository contains the text files required to build the:

mmCIF DDL Core Dictionary with extensions

This DDL dictionary is used by all PDBx mmCIF dictionary driven applications.  A text file
describing the components of this dictionary is contained in the file `base/mmcif_ddl-generator.dic`.

The full DDL dictionary can be built using the command:

```shell

scripts/Build.sh mmcif_ddl

   or by typing:

    make
```

The generated dictionary text file containing the current DDL2 dictionary is stored in `dist/mmcif_ddl.dic`.
Recent prior versions are stored in the the `archive` subdirectory.
