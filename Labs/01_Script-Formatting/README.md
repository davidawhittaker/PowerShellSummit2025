# Outline
In this lab, we'll discuss some best practices for code formatting.

The code in both example scripts does the same thing: it will split the complete works of Shakespeare from a single `.txt` file into individual files for each scene of each book. However, you'll notice there are significant differences in how easy the scripts are for the average person to interpret.

In the [01_Split-Shakespeare.ps1](01_Split-Shakespeare.ps1) script, there is no formatting whatsoever. This makes it extremely difficult to troubleshoot or add any functionality in the future. Let's start by taking care of some general formatting.

# Exercise 1 - Format document

If you've opened this repository in [VSCode](https://code.visualstudio.com/), you can simply invoke the command palette by using `CTRL`+`Shift`+`P` and type `Format Document`. Included in the [.vscode](./../../.vscode) folder are some code formatting settings that should serve as a decent starting point for developing your own style guidelines.

There are several published [style guides](https://github.com/PoshCode/PowerShellPracticeAndStyle) and [development guidelines](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines?view=powershell-7.5) available as reference points, but none of these are mandatory. Whatever formatting style you choose, the most important thing is to **be consistent**.

In terms of readability, some of the most important improvements you can make include:
- Indenting code blocks, such as with `if`, `else`, `foreach`, or `switch` keywords. Code blocks are enclosed various types of braces or brackets, depending on their functionality.
- Using one command (or set of commands if using the pipeline `|` operator) per line of code
- Choosing meaningful variable and function names; `$Books` is easier to read at a glance than `$mybookobj`.
- Avoiding the use of aliases, since these can often overlap with Windows executable files or Linux commands, and can have unintended consequences. Notable examples of these are the `dir` and `select` aliases.
- Using comments to document how different sections of code are intended to function; this can make it easier to walk through the logic inside a script during troubleshooting.

If you're using an IDE other than VSCode, try to format the [01_Split-Shakespeare.ps1](01_Split-Shakespeare.ps1) script using some of the suggestions above, and by using the [01_Split-Shakespeare-Clean.ps1](01_Split-Shakespeare-Clean.ps1) script as reference.