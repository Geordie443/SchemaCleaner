{:file, fileName} = {:file, "Fields.txt"}

newList =
  File.read!(fileName)
  # get rid of dollar sign
  |> String.replace(".$", "")
  # remove 3 digit numbers followed by colon and space
  |> String.replace(~r/(\d{3})(\: )/, "")
  # remove 2 digit numbers followed by colon and space
  |> String.replace(~r/(\d{2})(\: )/, "")
  # remove 1 digit numbers followed by colon and space
  |> String.replace(~r/(\d{1})(\: )/, "")
  # remove blank lines
  |> String.replace(~r/(\n)(.*)(\n)/, "\n")
  # put commas at the end of each line  
  |> String.replace(~r/(\n)/, ",\n-:")
  # gets rid of colon at last line and comma ending last entry
  |> String.slice(0..-5)

# adds colon at start
newList = ":" <> newList

fieldList = String.split(newList, "-")
listlen = length(fieldList)

# cleaning the list to have no quotes on single word names
cleanList = CleanFields.headFunction(fieldList, "")
cleanList = cleanList <> ","

# take user input for collection name
# gets string and trims uneccesarry characters 
collection =
  IO.gets("Which collection is this for? :")
  |> String.slice(0..-2)

fileOut = collection <> "_#{listlen}_Fields_Cleaned.txt"
IO.puts("Cleaning Complete !")
IO.puts("#{listlen} Schema Fields Cleaned\n")
# output the cleaned list  to file
File.write(fileOut, cleanList)

# ----------------------------------------------------------------------------------

defmodule CleanFields do
  def headFunction(fieldList, finalList) when length(fieldList) <= 1 do
    [last] = fieldList

    finalList =
      case String.contains?(last, ".") do
        true ->
          finalList <> last

        false ->
          noQuote = String.replace(last, ~r/(")/, "")
          finalList <> noQuote
      end

    finalList
  end

  def headFunction(fieldList, finalList) do
    [head | tail] = fieldList

    finalList =
      case String.contains?(head, ".") do
        true ->
          finalList <> head

        false ->
          noQuote = String.replace(head, ~r/(")/, "")
          finalList <> noQuote
      end

    headFunction(tail, finalList)
  end
end
