# PyTester - Automated Esko Tester (Python Migration)

Python migration of the Automated Esko Tester batch/JSX/VBS system.

## Structure

```
py_tester/
├── config/
│   └── aet.yaml              # Main configuration (replaces AET.cfg + .bat params)
├── core/
│   ├── orchestrator.py       # Main workflow
│   ├── illustrator_controller.py  # Multiplatform AI control (COM/AppleScript)
│   ├── jsx_runner.py         # Generates temporary JSX wrappers
│   └── task_scheduler.py     # CSV parsing and task management
├── processing/
│   ├── cleanup.py            # Output cleanup
│   ├── plugin_manager.py     # Plugin updates from Homer
│   ├── build_info.py         # Build info fetching
│   └── export_logs.py        # Log export
├── comparison/
│   └── nmt_wrapper.py        # NDLModelTest wrapper + TestQ generator
├── reporting/
│   ├── statistics.py         # XML statistics aggregation
│   ├── transform.py          # XSLT -> HTML
│   └── mailer.py             # Email notifications
├── utils/
│   ├── path_utils.py         # Cross-platform path handling
│   └── logging_utils.py      # Logging configuration
├── main.py                   # Entry point
└── requirements.txt
```

## Configuration

Edit `config/aet.yaml`:
- `system`: UNC paths and folder names
- `illustrator`: AI version, COM name, plugin paths
- `test_defaults`: Default T-prefixed variables for test runs
- `paths`: Input/output directory names
- `homer`: Build server configuration
- `comparison`: NMT tolerance and DPI settings
- `reporting`: Email configuration

## Usage

```bash
# Install dependencies
pip install -r requirements.txt

# Run all tests
python main.py

# Run specific CSV
python main.py --csv Create-DrugsSupp.csv

# Dry run (no AI)
python main.py --dry-run

# Custom config
python main.py --config config/my_config.yaml
```

## Test Defaults (T-prefixed Variables)

All variables from the original JSX that start with `T` are now in YAML:

```yaml
test_defaults:
  tester_name: "Dynamic Tables Tester"    # TRequestedTesterName
  process_subfolder: false                # TprocessSubfolder
  mask: "*.ai"                            # Tmask
  use_import_pdf: false                   # TuseImportPDF
  use_import_ndlpdf: false              # TuseImportNDLPDF
  output_type: 3                          # ToutputType
  trap_ticket: "-"                        # TtrapTicket
  ink_mapping_file: "-"                   # TinkMappingFile
```

## Multiplatform Support

- **Windows**: Uses `win32com.client` for COM automation
- **macOS**: Uses `osascript` (AppleScript)
- Paths automatically normalized for UNC/SMB
