# Explanation of Code Changes

This document provides a detailed explanation of the changes made to fix the bug in the `Algorithm::Bitonic::Sort` module.

My work on this task involved three main categories of changes:
1.  **Fixing the Core Sorting Logic:** The primary bug was in a helper function responsible for handling arrays with an odd number of elements. The fix involved correcting two separate logical flaws.
2.  **Improving the Test Suite:** I added a new, complex test case that specifically triggered the bug. I also made the existing tests more reliable and easier to read.
3.  **Environment and Repository Cleanup:** I fixed issues with the test environment (missing dependencies, broken tests) and added a `.gitignore` file to prevent committing build artifacts, as pointed out in the code review.

---

## 1. The Core Bug: Fixing `_bitonic_merge` and `_some_sorting_algorithm`

The main bug was located in how the algorithm handled lists that were not a power of two in size. The bitonic sort algorithm is most efficient with arrays of size 2, 4, 8, 16, etc. This codebase tries to support arrays of any size by splitting off "leftover" elements and inserting them back into the sorted list later. This insertion logic was flawed in two places.

### The First Flaw: Overwriting Results in `_bitonic_merge`

*   **Original Logic:**
    ```perl
    @num = (@first, @second);
    @num = _some_sorting_algorithm( $up, $single_bit, @first, @second ) if $single_bit ne 'NA';
    @num = _some_sorting_algorithm( $up, $single_bit_2, @first, @second ) if $single_bit_2 ne 'NA';
    ```
*   **Why It Didn't Work:** The problem was that the second call to `_some_sorting_algorithm` was using the original, unsorted data (`@first, @second`) as its input. If the first call successfully inserted an element (`$single_bit`), its result was stored in `@num`. However, the second call ignored that result and started over with the original data, effectively discarding the first insertion.

*   **The Fix:** I chained the calls together, so the result of the first operation becomes the input for the second.
    ```perl
    @num = (@first, @second);
    @num = _some_sorting_algorithm( $up, $single_bit, @num ) if $single_bit ne 'NA';
    @num = _some_sorting_algorithm( $up, $single_bit_2, @num ) if $single_bit_2 ne 'NA';
    ```
*   **Why This Works:** Now, the updated `@num` (which contains the first inserted element) is correctly passed to the second call. This ensures that both leftover elements are properly inserted into the final list.

### The Second Flaw: The Insertion Logic in `_some_sorting_algorithm`

*   **Original Logic:** The function used a `while` loop that removed elements from the beginning of the array (`shift @num`). It was complex and had a critical bug in its `return` statement, which would return a partially sorted list concatenated with the rest of the unprocessed list.

*   **Why It Didn't Work:** This approach was fragile and failed on complex cases, especially in descending sorts where the "leftover" element needed to be placed at the end of the array. The loop would finish, and the element would be appended incorrectly, leading to the wrong sort order as seen in the failing test.

*   **The Fix:** I replaced the entire function with a much simpler and more robust implementation. This new version is a standard insertion algorithm for a single element.
    ```perl
    sub _some_sorting_algorithm {
        my $up = shift;
        my $single_bit = shift;
        my @num = @_;
        my @num_new;
        my $inserted = 0;

        for my $curr (@num) {
            # If the correct insertion spot is found...
            if (!$inserted && (($up && $single_bit < $curr) || (!$up && $single_bit > $curr))) {
                push @num_new, $single_bit; # ...insert the element.
                $inserted = 1;
            }
            push @num_new, $curr; # Add the current element from the original list.
        }

        # If the element was never inserted (it's the largest/smallest), add it at the end.
        if (!$inserted) {
            push @num_new, $single_bit;
        }
        return @num_new;
    }
    ```
*   **Why This Works:** This logic is straightforward. It iterates through the already-sorted list and finds the first position where the new element (`$single_bit`) should be inserted based on the sorting direction (`$up`). A flag (`$inserted`) ensures it's only inserted once. If the loop completes and the element hasn't been inserted, it means the element belongs at the very end of the list. This handles all cases correctly and reliably.

---

## 2. Test Suite Improvements (`t/01-sort.t`)

*   **Added a Failing Test Case:** I introduced a new test with a more complex, odd-lengthed array `(5, 2, 8, 1, 9, -1, 0, 5, 2, 8, 1)`. This array includes duplicates and negative numbers, which successfully exposed the subtle bugs in the original sorting logic that simpler cases missed.
*   **Increased Test Reliability:** The original tests used Perl's experimental "smart match" operator (`~~`). This operator is not recommended for production code because its behavior can be unpredictable. I replaced it with `is_deeply` from `Test::More`, which is the standard and most reliable way to verify that two arrays are identical.
*   **Improved Code Clarity:** Based on Copilot's feedback, I renamed the generic `@result` variable in the test file to `@result_asc` and `@result_desc`. This makes the test's intent clearer and easier to understand for future developers.
