## 2026-07-27 - [Bash / Shell Script Optimization]
**Learning:** Parsing configurations via a loop of individual grep processes (such as `get_val()`) introduces significant overhead by spawning subprocesses. Combining multiple extractions into a single grep pipeline with `eval` dramatically reduces runtime overhead (from ~2.5s down to ~0.6s for 100 iterations, a ~75% speedup).
**Action:** Use a single-pass `eval $(grep -oE ... | sed ...)` or `awk` to parse multiple environment / config variables at once in shell scripts.
