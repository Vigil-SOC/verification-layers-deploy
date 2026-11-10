# Seed 1

Run 2026-11-06, 14:48 UTC to about 20:00, on engine commit
[`2e5a2dc`](https://github.com/Vigil-SOC/verification-layers/commit/2e5a2dcce41cda465c73abae3193151e1b37da18).

- 20 of 36 SlopCodeBench problems (`random.Random(42)`), 101 checkpoints per arm.
- Claude Sonnet 5.5 at medium effort in Claude Code 2.1.318, on Vertex AI, for every role.
- Arms: A plain Claude Code, B live verification with no kept tests, C = B plus a
  reviewer that can send work back up to twice, D tests first.
- Costs are tokens re-priced at Anthropic list price, not the Vertex bill.
- One seed, one model, greenfield problems. The reviewer reads code and does not run it.

## Files

- `table.md`: the summary table and paired comparisons against A (95% bootstrap CI over problems).
- `checkpoints.csv`: one row per arm and checkpoint, the data behind the table.
- `logs/`: the run log for each arm, plus the shadow-review log.
