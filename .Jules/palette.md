# Palette's Journal — Ruhland Rice

This journal stores critical UX and accessibility learnings.

## 2024-07-27 - Yad Tooltips for Forms and Lists
**Learning:** Yad supports inline tooltips for form fields using the `LABEL!TOOLTIP:TYPE` syntax, and list item tooltips using the column type `:TIP`. This allows us to keep the configuration UI clean and elegant while ensuring that every option has accessible, on-demand explanations on hover or focus.
**Action:** Utilize `LABEL!TOOLTIP:TYPE` for all complex settings forms, and use `COLUMN:TIP` to provide description tooltips on list rows.
