#!/usr/bin/python
table_cols = 9
table_rows = 9

list_size = 9

with open("vimwiki.snippets", "w") as file:

    # generate tables
    for i in range(1, table_cols+1):
        for j in range(1, table_rows+1):

            file.write("snippet table{}x{} \"table{}x{}\" A\n".format(i, j, i, j))

            for k in range(0, i):

                file.write("|")

                for l in range(0, j):

                    if k == 0 and l == 0:

                        file.write(" ${0} |")

                    else:

                        file.write(" |")

                file.write("\n")

            file.write("endsnippet\n\n")

    # generate lists
    for i in range(1, list_size+1):

        file.write("snippet list{} \"list{}\" A\n".format(i, i))

        for k in range(0, i):

            if k == i-1:
                file.write("  * ${{{}}}".format(0))
            else:
                file.write("  * ${{{}}}".format(k+1))

            file.write("\n")

        file.write("endsnippet\n\n")

    # generate numbered lists
    for i in range(1, list_size+1):

        file.write("snippet numlist{} \"numlist{}\" A\n".format(i, i))

        for k in range(0, i):

            if k == i-1:
                file.write("  {}. ${{{}}}".format(k+1, 0))
            else:
                file.write("  {}. ${{{}}}".format(k+1, k+1))

            file.write("\n")

        file.write("endsnippet\n\n")

    # generate checklists
    for i in range(1, list_size+1):

        file.write("snippet check{} \"checklist{}\" A\n".format(i, i))

        for k in range(0, i):

            if k == i-1:
                file.write("  * [ ] ${{{}}}".format(0))
            else:
                file.write("  * [ ] ${{{}}}".format(k+1))

            file.write("\n")

        file.write("endsnippet\n\n")
