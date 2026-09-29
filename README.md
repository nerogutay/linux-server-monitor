
# Linux Server Monitor

A Bash-based monitoring tool developed on Fedora Linux
to practice Linux administration, system monitoring,
and troubleshooting.

## Features

- Checks the status of system services.
- Monitors disk usage.
- Monitors RAM utilization.
- Reports system load average.
- Checks CPU utilization.
- Lists the top 5 processes by CPU usage.
- Classifies process CPU usage using configurable thresholds.

## Requirements

- Linux
- Bash
- procps-ng
- awk
- bc

## Usage

Clone the repository or download the project files.

Make the script executable:

```bash
chmod +x monitor.sh
```

Run the monitor:

```bash
./monitor.sh
```

Alternatively, run it using Bash:

```bash
bash monitor.sh
```

## Process Alert Thresholds

| CPU Usage | Status |
|-----------|--------|
| Below 50% | OK |
| 50% to below 80% | WARNING |
| 80% or above | CRITICAL |

These thresholds are configurable in the script.

## Technologies

- Linux
- Bash
- GNU awk
- Linux process and system utilities

## Author

Electronics Engineer specializing in Networks
and Telecommunications.

## Future Improvements

- Add log file generation.
- Add configurable alert thresholds.
- Improve memory monitoring.
- Add automated tests.
- Support additional services.
