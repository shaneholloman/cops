# Tree-sitter Bash Integration Guide

Note, I am grappling with this concept of using tree-sitter to parse bash scripts. So forgive the incomplete nature of this document as its just for me at this point.

## Overview

This guide provides a lightweight Tree-sitter integration for Bash syntax parsing using globally installed tools with minimal project footprint.

## Prerequisites

- Volta installed globally
- Node.js installed globally
- Git installed

## Installation

1. Create tools directory and install grammar:

   ```bash
   mkdir -p tools/treesitter/grammars
   cd tools/treesitter/grammars
   git clone --depth 1 https://github.com/tree-sitter/tree-sitter-bash
   cd tree-sitter-bash
   npm install
   npm audit fix
   tree-sitter generate
   ```

2. Verify installation:

   ```bash
   tree-sitter test
   ```

3. To update the grammar:

   ```bash
   cd tools/treesitter/grammars/tree-sitter-bash
   git pull
   npm install
   tree-sitter generate
   ```

4. To remove the grammar:

   ```bash
   rm -rf tools/treesitter/grammars/tree-sitter-bash
   ```

## Usage

### Testing Grammar

```bash
cd tools/treesitter/grammars/tree-sitter-bash
tree-sitter test
```

### Updating Grammar

```bash
cd tools/treesitter/grammars/tree-sitter-bash
git pull
npm install
tree-sitter generate
```

```bash
 shaneholloman @ bird.yoyo.io ❯ cops ❯ main ❯ cd /Users/shaneholloman/Dropbox/shane/git/_sources/cops/tools/treesitter/grammars/tree
-sitter-bash && tree-sitter test
  commands:
      1. ✓ Commands
      2. ✓ Commands with arguments
      3. ✓ Quoted command names
      4. ✓ Commands with numeric arguments
      5. ✓ Commands with environment variables
      6. ✓ Empty environment variables
      7. ✓ File redirects
      8. ✓ File redirects (noclobber override)
      9. ✓ Heredoc redirects
     10. ✓ Heredocs with variables
     11. ✓ Heredocs with file redirects
     12. ✓ Heredocs with many file redirects
     13. ✓ Heredocs with pipes
     14. ✓ Heredocs with escaped expansions
     15. ✓ Quoted Heredocs
     16. ✓ Heredocs with indented closing delimiters
     17. ✓ Heredocs with empty bodies
     18. ✓ Heredocs with weird characters
     19. ✓ Heredocs with a rhs statement
     20. ✓ Heredocs with a $ that is not an expansion
     21. ✓ Nested Heredocs
     22. ✓ Herestrings
     23. ✓ Subscripts
     24. ✓ Bare $
     25. ✓ Arithmetic with command substitution
     26. ✓ Ralative path without dots
  crlf:
     27. ✓ Variables with CRLF line endings
  literals:
     28. ✓ Literal words
     29. ✓ Words with special characters
     30. ✓ Simple variable expansions
     31. ✓ Special variable expansions
     32. ✓ Variable expansions
     33. ✓ Variable expansions with operators
     34. ✓ More Variable expansions with operators
     35. ✓ Variable expansions in strings
     36. ✓ Variable expansions with regexes
     37. ✓ Other variable expansion operators
     38. ✓ Variable Expansions: Length
     39. ✓ Variable Expansions with operators
     40. ✓ Variable Expansions: Bizarre Cases
     41. ✓ Variable Expansions: Weird Cases
     42. ✓ Variable Expansions: Regex
     43. ✓ Words ending with '$'
     44. ✓ Command substitutions
     45. ✓ Process substitutions
     46. ✓ Single quoted strings
     47. ✓ Double quoted strings
     48. ✓ Strings containing command substitutions
     49. ✓ Strings containing escape sequence
     50. ✓ Strings containing special characters
     51. ✓ Strings with ANSI-C quoting
     52. ✓ Arrays and array expansions
     53. ✓ Escaped characters in strings
     54. ✓ Words containing bare '#'
     55. ✓ Words containing # that are not comments
     56. ✓ Variable assignments immediately followed by a terminator
     57. ✓ Multiple variable assignments
     58. ✓ Arithmetic expansions
     59. ✓ Concatenation with double backticks
     60. ✓ Brace expressions and lookalikes
  programs:
     61. ✓ Comments
     62. ✓ Escaped newlines
     63. ✓ escaped newline immediately after a char
     64. ✓ Escaped whitespace
     65. ✓ Files without trailing terminators
  statements:
     66. ✓ Pipelines
     67. ✓ Lists
     68. ✓ While statements
     69. ✓ Until statements
     70. ✓ While statements with IO redirects
     71. ✓ For statements
     72. ✓ Select statements
     73. ✓ C-style for statements
     74. ✓ If statements
     75. ✓ If statements with conditional expressions
     76. ✓ If statements with negated command
     77. ✓ If statements with command
     78. ✓ If statements with variable assignment by command substitution
     79. ✓ If statements with negated variable assignment by command substitution
     80. ✓ If statements with variable assignment
     81. ✓ If statements with negated variable assignment
     82. ✓ Case statements
     83. ✓ Test commands
     84. ✓ Test commands with ternary
     85. ✓ Ternary expressions
     86. ✓ Test commands with regexes
     87. ✓ Test command paren statefulness with a case glob
     88. ✓ Subshells
     89. ✓ Function definitions
     90. ✓ Variable declaration: declare & typeset
     91. ✓ Variable declaration: readonly
     92. ✓ Variable declaration: local
     93. ✓ Variable declaration: export
     94. ✓ Variable declaration: command substitution with semi-colon
     95. ✓ Command substution with $ and backticks
     96. ✓ Expressions passed to declaration commands
     97. ✓ Unset commands
     98. ✓ Compound statements
     99. ✓ If condition with subshell
    100. ✓ While condition with subshell
 󰎙 22.13.0  shaneholloman @ bird.yoyo.io ❯ tree-sitter-bash ❯ master ❯
```

```bash
cd /Users/shaneholloman/Dropbox/shane/git/_sources/cops/tools/treesitter/grammars/tree
-sitter-bash && tree-sitter generate && tree-sitter build && tree-sitter parse /Users/shaneholloman/Dropbox/shane/git/_sources/cops/co
ps-setup.sh
```

```bash
 shaneholloman @ bird.yoyo.io ❯ cops ❯ main ❯ cd /Users/shaneholloman/Dropbox/shane/git/_sources/cops/tools/treesitter/grammars/tree
-sitter-bash && tree-sitter generate && tree-sitter build && tree-sitter parse /Users/shaneholloman/Dropbox/shane/git/_sources/cops/co
ps-setup.sh
(program [0, 0] - [166, 0]
  (comment [0, 0] - [0, 11])
  (comment [1, 0] - [1, 23])
  (comment [3, 0] - [3, 37])
  (command [4, 0] - [4, 6]
    name: (command_name [4, 0] - [4, 3]
      (word [4, 0] - [4, 3]))
    argument: (word [4, 4] - [4, 6]))
  (command [5, 0] - [5, 6]
    name: (command_name [5, 0] - [5, 3]
      (word [5, 0] - [5, 3]))
    argument: (word [5, 4] - [5, 6]))
  (comment [7, 0] - [7, 53])
  (if_statement [8, 0] - [16, 2]
    condition: (redirected_statement [8, 3] - [8, 30]
      body: (negated_command [8, 3] - [8, 18]
        (command [8, 5] - [8, 18]
          name: (command_name [8, 5] - [8, 12]
            (word [8, 5] - [8, 12]))
          argument: (word [8, 13] - [8, 15])
          argument: (word [8, 16] - [8, 18])))
      redirect: (file_redirect [8, 19] - [8, 30]
        destination: (word [8, 21] - [8, 30])))
    (command [9, 2] - [9, 56]
      name: (command_name [9, 2] - [9, 6]
        (word [9, 2] - [9, 6]))
      argument: (string [9, 7] - [9, 56]
        (string_content [9, 8] - [9, 55])))
    (if_statement [10, 2] - [15, 4]
      condition: (redirected_statement [10, 5] - [10, 32]
        body: (command [10, 5] - [10, 20]
          name: (command_name [10, 5] - [10, 12]
            (word [10, 5] - [10, 12]))
          argument: (word [10, 13] - [10, 15])
          argument: (word [10, 16] - [10, 20]))
        redirect: (file_redirect [10, 21] - [10, 32]
          destination: (word [10, 23] - [10, 32])))
      (command [11, 4] - [11, 19]
        name: (command_name [11, 4] - [11, 8]
          (word [11, 4] - [11, 8]))
        argument: (word [11, 9] - [11, 16])
        argument: (word [11, 17] - [11, 19]))
      (else_clause [12, 2] - [15, 0]
        (command [13, 4] - [13, 64]
          name: (command_name [13, 4] - [13, 8]
            (word [13, 4] - [13, 8]))
          argument: (string [13, 9] - [13, 64]
            (string_content [13, 10] - [13, 63])))
        (command [14, 4] - [14, 10]
          name: (command_name [14, 4] - [14, 8]
            (word [14, 4] - [14, 8]))
          argument: (number [14, 9] - [14, 10])))))
  (comment [18, 0] - [18, 30])
  (variable_assignment [19, 0] - [19, 16]
    name: (variable_name [19, 0] - [19, 10])
    value: (word [19, 11] - [19, 16]))
  (variable_assignment [20, 0] - [20, 10]
    name: (variable_name [20, 0] - [20, 7])
    value: (string [20, 8] - [20, 10]))
  (variable_assignment [21, 0] - [21, 7]
    name: (variable_name [21, 0] - [21, 4])
    value: (string [21, 5] - [21, 7]))
  (variable_assignment [22, 0] - [22, 7]
    name: (variable_name [22, 0] - [22, 4])
    value: (string [22, 5] - [22, 7]))
  (variable_assignment [23, 0] - [23, 12]
    name: (variable_name [23, 0] - [23, 9])
    value: (string [23, 10] - [23, 12]))
  (variable_assignment [24, 0] - [24, 13]
    name: (variable_name [24, 0] - [24, 7])
    value: (word [24, 8] - [24, 13]))
  (variable_assignment [25, 0] - [25, 15]
    name: (variable_name [25, 0] - [25, 9])
    value: (word [25, 10] - [25, 15]))
  (function_definition [27, 0] - [37, 1]
    name: (word [27, 0] - [27, 11])
    body: (compound_statement [27, 14] - [37, 1]
      (command [28, 2] - [28, 37]
        name: (command_name [28, 2] - [28, 8]
          (word [28, 2] - [28, 8]))
        argument: (string [28, 9] - [28, 32]
          (string_content [28, 10] - [28, 31]))
        argument: (string [28, 33] - [28, 37]
          (simple_expansion [28, 34] - [28, 36]
            (special_variable_name [28, 35] - [28, 36]))))
      (command [29, 2] - [29, 23]
        name: (command_name [29, 2] - [29, 8]
          (word [29, 2] - [29, 8]))
        argument: (string [29, 9] - [29, 23]
          (string_content [29, 10] - [29, 22])))
      (command [30, 2] - [30, 64]
        name: (command_name [30, 2] - [30, 8]
          (word [30, 2] - [30, 8]))
        argument: (string [30, 9] - [30, 64]
          (string_content [30, 10] - [30, 63])))
      (command [31, 2] - [31, 84]
        name: (command_name [31, 2] - [31, 8]
          (word [31, 2] - [31, 8]))
        argument: (string [31, 9] - [31, 84]
          (string_content [31, 10] - [31, 83])))
      (command [32, 2] - [32, 73]
        name: (command_name [32, 2] - [32, 8]
          (word [32, 2] - [32, 8]))
        argument: (string [32, 9] - [32, 73]
          (string_content [32, 10] - [32, 72])))
      (command [33, 2] - [33, 86]
        name: (command_name [33, 2] - [33, 8]
          (word [33, 2] - [33, 8]))
        argument: (string [33, 9] - [33, 86]
          (string_content [33, 10] - [33, 85])))
      (command [34, 2] - [34, 62]
        name: (command_name [34, 2] - [34, 8]
          (word [34, 2] - [34, 8]))
        argument: (string [34, 9] - [34, 62]
          (string_content [34, 10] - [34, 61])))
      (command [35, 2] - [35, 73]
        name: (command_name [35, 2] - [35, 8]
          (word [35, 2] - [35, 8]))
        argument: (string [35, 9] - [35, 73]
          (string_content [35, 10] - [35, 72])))
      (command [36, 2] - [36, 57]
        name: (command_name [36, 2] - [36, 8]
          (word [36, 2] - [36, 8]))
        argument: (string [36, 9] - [36, 57]
          (string_content [36, 10] - [36, 56])))))
  (while_statement [39, 0] - [93, 4]
    condition: (test_command [39, 6] - [39, 20]
      (binary_expression [39, 9] - [39, 17]
        left: (simple_expansion [39, 9] - [39, 11]
          (special_variable_name [39, 10] - [39, 11]))
        operator: (test_operator [39, 12] - [39, 15])
        right: (number [39, 16] - [39, 17])))
    body: (do_group [39, 22] - [93, 4]
      (case_statement [40, 2] - [92, 6]
        value: (simple_expansion [40, 7] - [40, 9]
          (variable_name [40, 8] - [40, 9]))
        (case_item [41, 2] - [44, 6]
          value: (extglob_pattern [41, 2] - [41, 14])
          (variable_assignment [42, 4] - [42, 19]
            name: (variable_name [42, 4] - [42, 14])
            value: (word [42, 15] - [42, 19]))
          (command [43, 4] - [43, 9]
            name: (command_name [43, 4] - [43, 9]
              (word [43, 4] - [43, 9]))))
        (case_item [45, 2] - [48, 6]
          value: (extglob_pattern [45, 2] - [45, 11])
          (variable_assignment [46, 4] - [46, 16]
            name: (variable_name [46, 4] - [46, 11])
            value: (word [46, 12] - [46, 16]))
          (command [47, 4] - [47, 9]
            name: (command_name [47, 4] - [47, 9]
              (word [47, 4] - [47, 9]))))
        (case_item [49, 2] - [53, 6]
          value: (extglob_pattern [49, 2] - [49, 8])
          (variable_assignment [50, 4] - [50, 18]
            name: (variable_name [50, 4] - [50, 11])
            value: (string [50, 12] - [50, 18]
              (string_content [50, 13] - [50, 17])))
          (variable_assignment [51, 4] - [51, 18]
            name: (variable_name [51, 4] - [51, 13])
            value: (word [51, 14] - [51, 18]))
          (command [52, 4] - [52, 9]
            name: (command_name [52, 4] - [52, 9]
              (word [52, 4] - [52, 9]))))
        (case_item [54, 2] - [61, 6]
          value: (extglob_pattern [54, 2] - [54, 16])
          (variable_assignment [55, 4] - [55, 18]
            name: (variable_name [55, 4] - [55, 11])
            value: (string [55, 12] - [55, 18]
              (string_content [55, 13] - [55, 17])))
          (if_statement [56, 4] - [59, 6]
            condition: (test_command [56, 7] - [56, 36]
              (binary_expression [56, 10] - [56, 33]
                left: (binary_expression [56, 10] - [56, 26]
                  left: (binary_expression [56, 10] - [56, 18]
                    left: (simple_expansion [56, 10] - [56, 12]
                      (special_variable_name [56, 11] - [56, 12]))
                    operator: (test_operator [56, 13] - [56, 16])
                    right: (number [56, 17] - [56, 18]))
                  right: (unary_expression [56, 22] - [56, 26]
                    (simple_expansion [56, 24] - [56, 26]
                      (variable_name [56, 25] - [56, 26]))))
                right: (regex [56, 30] - [56, 33])))
            (variable_assignment [57, 6] - [57, 15]
              name: (variable_name [57, 6] - [57, 10])
              value: (string [57, 11] - [57, 15]
                (simple_expansion [57, 12] - [57, 14]
                  (variable_name [57, 13] - [57, 14]))))
            (command [58, 6] - [58, 11]
              name: (command_name [58, 6] - [58, 11]
                (word [58, 6] - [58, 11]))))
          (command [60, 4] - [60, 9]
            name: (command_name [60, 4] - [60, 9]
              (word [60, 4] - [60, 9]))))
        (case_item [62, 2] - [72, 6]
          value: (extglob_pattern [62, 2] - [62, 11])
          (if_statement [63, 4] - [67, 6]
            condition: (test_command [63, 7] - [63, 21]
              (binary_expression [63, 10] - [63, 18]
                left: (simple_expansion [63, 10] - [63, 12]
                  (special_variable_name [63, 11] - [63, 12]))
                operator: (test_operator [63, 13] - [63, 16])
                right: (number [63, 17] - [63, 18])))
            (command [64, 6] - [64, 51]
              name: (command_name [64, 6] - [64, 17]
                (word [64, 6] - [64, 17]))
              argument: (string [64, 18] - [64, 51]
                (string_content [64, 19] - [64, 50])))
            (command [65, 6] - [65, 17]
              name: (command_name [65, 6] - [65, 17]
                (word [65, 6] - [65, 17])))
            (command [66, 6] - [66, 12]
              name: (command_name [66, 6] - [66, 10]
                (word [66, 6] - [66, 10]))
              argument: (number [66, 11] - [66, 12])))
          (variable_assignment [68, 4] - [68, 21]
            name: (variable_name [68, 4] - [68, 11])
            value: (string [68, 12] - [68, 21]
              (string_content [68, 13] - [68, 20])))
          (variable_assignment [69, 4] - [69, 13]
            name: (variable_name [69, 4] - [69, 8])
            value: (string [69, 9] - [69, 13]
              (simple_expansion [69, 10] - [69, 12]
                (variable_name [69, 11] - [69, 12]))))
          (variable_assignment [70, 4] - [70, 13]
            name: (variable_name [70, 4] - [70, 8])
            value: (string [70, 9] - [70, 13]
              (simple_expansion [70, 10] - [70, 12]
                (variable_name [70, 11] - [70, 12]))))
          (command [71, 4] - [71, 11]
            name: (command_name [71, 4] - [71, 9]
              (word [71, 4] - [71, 9]))
            argument: (number [71, 10] - [71, 11])))
        (case_item [73, 2] - [82, 6]
          value: (extglob_pattern [73, 2] - [73, 15])
          (if_statement [74, 4] - [78, 6]
            condition: (test_command [74, 7] - [74, 21]
              (binary_expression [74, 10] - [74, 18]
                left: (simple_expansion [74, 10] - [74, 12]
                  (special_variable_name [74, 11] - [74, 12]))
                operator: (test_operator [74, 13] - [74, 16])
                right: (number [74, 17] - [74, 18])))
            (command [75, 6] - [75, 55]
              name: (command_name [75, 6] - [75, 17]
                (word [75, 6] - [75, 17]))
              argument: (string [75, 18] - [75, 55]
                (string_content [75, 19] - [75, 54])))
            (command [76, 6] - [76, 17]
              name: (command_name [76, 6] - [76, 17]
                (word [76, 6] - [76, 17])))
            (command [77, 6] - [77, 12]
              name: (command_name [77, 6] - [77, 10]
                (word [77, 6] - [77, 10]))
              argument: (number [77, 11] - [77, 12])))
          (variable_assignment [79, 4] - [79, 25]
            name: (variable_name [79, 4] - [79, 11])
            value: (string [79, 12] - [79, 25]
              (string_content [79, 13] - [79, 24])))
          (variable_assignment [80, 4] - [80, 18]
            name: (variable_name [80, 4] - [80, 13])
            value: (string [80, 14] - [80, 18]
              (simple_expansion [80, 15] - [80, 17]
                (variable_name [80, 16] - [80, 17]))))
          (command [81, 4] - [81, 11]
            name: (command_name [81, 4] - [81, 9]
              (word [81, 4] - [81, 9]))
            argument: (number [81, 10] - [81, 11])))
        (case_item [83, 2] - [86, 6]
          value: (word [83, 2] - [83, 4])
          value: (extglob_pattern [83, 7] - [83, 13])
          (command [84, 4] - [84, 15]
            name: (command_name [84, 4] - [84, 15]
              (word [84, 4] - [84, 15])))
          (command [85, 4] - [85, 10]
            name: (command_name [85, 4] - [85, 8]
              (word [85, 4] - [85, 8]))
            argument: (number [85, 9] - [85, 10])))
        (case_item [87, 2] - [91, 6]
          value: (extglob_pattern [87, 2] - [87, 3])
          (command [88, 4] - [88, 36]
            name: (command_name [88, 4] - [88, 15]
              (word [88, 4] - [88, 15]))
            argument: (string [88, 16] - [88, 36]
              (string_content [88, 17] - [88, 33])
              (simple_expansion [88, 33] - [88, 35]
                (variable_name [88, 34] - [88, 35]))))
          (command [89, 4] - [89, 15]
            name: (command_name [89, 4] - [89, 15]
              (word [89, 4] - [89, 15])))
          (command [90, 4] - [90, 10]
            name: (command_name [90, 4] - [90, 8]
              (word [90, 4] - [90, 8]))
            argument: (number [90, 9] - [90, 10]))))))
  (comment [95, 0] - [95, 22])
  (variable_assignment [96, 0] - [96, 25]
    name: (variable_name [96, 0] - [96, 11])
    value: (string [96, 12] - [96, 25]
      (string_content [96, 13] - [96, 24])))
  (declaration_command [97, 0] - [97, 17]
    (variable_name [97, 7] - [97, 17]))
  (variable_assignment [99, 0] - [99, 60]
    name: (variable_name [99, 0] - [99, 9])
    value: (command_substitution [99, 10] - [99, 60]
      (pipeline [99, 12] - [99, 59]
        (command [99, 12] - [99, 48]
          name: (command_name [99, 12] - [99, 14]
            (word [99, 12] - [99, 14]))
          argument: (word [99, 15] - [99, 19])
          argument: (raw_string [99, 20] - [99, 33])
          argument: (string [99, 34] - [99, 48]
            (simple_expansion [99, 35] - [99, 47]
              (variable_name [99, 36] - [99, 47]))))
        (command [99, 51] - [99, 59]
          name: (command_name [99, 51] - [99, 59]
            (word [99, 51] - [99, 59]))))))
  (declaration_command [100, 0] - [100, 16]
    (variable_name [100, 7] - [100, 16]))
  (comment [102, 0] - [102, 45])
  (variable_assignment [103, 0] - [103, 13]
    name: (variable_name [103, 0] - [103, 7])
    value: (string [103, 8] - [103, 13]
      (string_content [103, 9] - [103, 12])))
  (comment [104, 0] - [104, 33])
  (comment [105, 0] - [105, 27])
  (command [106, 0] - [106, 29]
    name: (command_name [106, 0] - [106, 6]
      (word [106, 0] - [106, 6]))
    argument: (string [106, 7] - [106, 29]
      (expansion [106, 8] - [106, 18]
        (variable_name [106, 10] - [106, 17]))
      (string_content [106, 18] - [106, 28])))
  (comment [107, 0] - [107, 35])
  (comment [108, 0] - [108, 27])
  (command [109, 0] - [109, 31]
    name: (command_name [109, 0] - [109, 6]
      (word [109, 0] - [109, 6]))
    argument: (string [109, 7] - [109, 31]
      (expansion [109, 8] - [109, 18]
        (variable_name [109, 10] - [109, 17]))
      (string_content [109, 18] - [109, 30])))
  (comment [110, 0] - [110, 33])
  (comment [111, 0] - [111, 27])
  (command [112, 0] - [112, 29]
    name: (command_name [112, 0] - [112, 6]
      (word [112, 0] - [112, 6]))
    argument: (string [112, 7] - [112, 29]
      (expansion [112, 8] - [112, 18]
        (variable_name [112, 10] - [112, 17]))
      (string_content [112, 18] - [112, 28])))
  (comment [113, 0] - [113, 33])
  (comment [114, 0] - [114, 27])
  (command [115, 0] - [115, 29]
    name: (command_name [115, 0] - [115, 6]
      (word [115, 0] - [115, 6]))
    argument: (string [115, 7] - [115, 29]
      (expansion [115, 8] - [115, 18]
        (variable_name [115, 10] - [115, 17]))
      (string_content [115, 18] - [115, 28])))
  (comment [116, 0] - [116, 32])
  (comment [117, 0] - [117, 27])
  (command [118, 0] - [118, 28]
    name: (command_name [118, 0] - [118, 6]
      (word [118, 0] - [118, 6]))
    argument: (string [118, 7] - [118, 28]
      (expansion [118, 8] - [118, 18]
        (variable_name [118, 10] - [118, 17]))
      (string_content [118, 18] - [118, 27])))
  (comment [119, 0] - [119, 34])
  (comment [120, 0] - [120, 27])
  (command [121, 0] - [121, 30]
    name: (command_name [121, 0] - [121, 6]
      (word [121, 0] - [121, 6]))
    argument: (string [121, 7] - [121, 30]
      (expansion [121, 8] - [121, 18]
        (variable_name [121, 10] - [121, 17]))
      (string_content [121, 18] - [121, 29])))
  (comment [122, 0] - [122, 48])
  (comment [123, 0] - [123, 27])
  (command [124, 0] - [124, 44]
    name: (command_name [124, 0] - [124, 6]
      (word [124, 0] - [124, 6]))
    argument: (string [124, 7] - [124, 44]
      (expansion [124, 8] - [124, 18]
        (variable_name [124, 10] - [124, 17]))
      (string_content [124, 18] - [124, 43])))
  (comment [125, 0] - [125, 38])
  (comment [126, 0] - [126, 27])
  (command [127, 0] - [127, 34]
    name: (command_name [127, 0] - [127, 6]
      (word [127, 0] - [127, 6]))
    argument: (string [127, 7] - [127, 34]
      (expansion [127, 8] - [127, 18]
        (variable_name [127, 10] - [127, 17]))
      (string_content [127, 18] - [127, 33])))
  (comment [128, 0] - [128, 34])
  (comment [129, 0] - [129, 27])
  (command [130, 0] - [130, 30]
    name: (command_name [130, 0] - [130, 6]
      (word [130, 0] - [130, 6]))
    argument: (string [130, 7] - [130, 30]
      (expansion [130, 8] - [130, 18]
        (variable_name [130, 10] - [130, 17]))
      (string_content [130, 18] - [130, 29])))
  (comment [131, 0] - [131, 37])
  (comment [132, 0] - [132, 27])
  (command [133, 0] - [133, 33]
    name: (command_name [133, 0] - [133, 6]
      (word [133, 0] - [133, 6]))
    argument: (string [133, 7] - [133, 33]
      (expansion [133, 8] - [133, 18]
        (variable_name [133, 10] - [133, 17]))
      (string_content [133, 18] - [133, 32])))
  (comment [134, 0] - [134, 34])
  (comment [135, 0] - [135, 27])
  (command [136, 0] - [136, 30]
    name: (command_name [136, 0] - [136, 6]
      (word [136, 0] - [136, 6]))
    argument: (string [136, 7] - [136, 30]
      (expansion [136, 8] - [136, 18]
        (variable_name [136, 10] - [136, 17]))
      (string_content [136, 18] - [136, 29])))
  (comment [137, 0] - [137, 31])
  (comment [138, 0] - [138, 27])
  (command [139, 0] - [139, 27]
    name: (command_name [139, 0] - [139, 6]
      (word [139, 0] - [139, 6]))
    argument: (string [139, 7] - [139, 27]
      (expansion [139, 8] - [139, 18]
        (variable_name [139, 10] - [139, 17]))
      (string_content [139, 18] - [139, 26])))
  (comment [141, 0] - [141, 36])
  (declaration_command [142, 0] - [142, 16]
    (variable_name [142, 7] - [142, 16]))
  (comment [144, 0] - [144, 36])
  (if_statement [145, 0] - [162, 2]
    condition: (test_command [145, 3] - [145, 22]
      (unary_expression [145, 6] - [145, 19]
        operator: (test_operator [145, 6] - [145, 8])
        (string [145, 9] - [145, 19]
          (simple_expansion [145, 10] - [145, 18]
            (variable_name [145, 11] - [145, 18])))))
    (case_statement [146, 2] - [160, 6]
      value: (string [146, 7] - [146, 17]
        (simple_expansion [146, 8] - [146, 16]
          (variable_name [146, 9] - [146, 16])))
      (case_item [147, 2] - [149, 6]
        value: (word [147, 2] - [147, 6])
        (command [148, 4] - [148, 24]
          name: (command_name [148, 4] - [148, 16]
            (word [148, 4] - [148, 16]))
          argument: (string [148, 17] - [148, 24]
            (simple_expansion [148, 18] - [148, 23]
              (variable_name [148, 19] - [148, 23])))))
      (case_item [150, 2] - [152, 6]
        value: (word [150, 2] - [150, 9])
        (command [151, 4] - [151, 46]
          name: (command_name [151, 4] - [151, 16]
            (word [151, 4] - [151, 16]))
          argument: (string [151, 17] - [151, 24]
            (simple_expansion [151, 18] - [151, 23]
              (variable_name [151, 19] - [151, 23])))
          argument: (string [151, 25] - [151, 32]
            (simple_expansion [151, 26] - [151, 31]
              (variable_name [151, 27] - [151, 31])))
          argument: (string [151, 33] - [151, 35])
          argument: (string [151, 36] - [151, 46]
            (simple_expansion [151, 37] - [151, 45]
              (variable_name [151, 38] - [151, 45])))))
      (case_item [153, 2] - [155, 6]
        value: (extglob_pattern [153, 2] - [153, 13])
        (command [154, 4] - [154, 39]
          name: (command_name [154, 4] - [154, 15]
            (word [154, 4] - [154, 15]))
          argument: (string [154, 16] - [154, 28]
            (simple_expansion [154, 17] - [154, 27]
              (variable_name [154, 18] - [154, 27])))
          argument: (string [154, 29] - [154, 39]
            (simple_expansion [154, 30] - [154, 38]
              (variable_name [154, 31] - [154, 38])))))
      (case_item [156, 2] - [159, 6]
        value: (word [156, 2] - [156, 6])
        (command [157, 4] - [157, 40]
          name: (command_name [157, 4] - [157, 16]
            (word [157, 4] - [157, 16]))
          argument: (string [157, 17] - [157, 40]
            (string_content [157, 18] - [157, 39])))
        (command [158, 4] - [158, 16]
          name: (command_name [158, 4] - [158, 16]
            (word [158, 4] - [158, 16])))))
    (command [161, 2] - [161, 8]
      name: (command_name [161, 2] - [161, 6]
        (word [161, 2] - [161, 6]))
      argument: (number [161, 7] - [161, 8])))
  (comment [164, 0] - [164, 49])
  (command [165, 0] - [165, 4]
    name: (command_name [165, 0] - [165, 4]
      (word [165, 0] - [165, 4]))))
 󰎙 22.13.0  shaneholloman @ bird.yoyo.io ❯ tree-sitter-bash ❯ master ❯
```
