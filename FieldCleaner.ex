# make a file called Fields.txt with the schemaKeys from portal with 0: "_id" being the first line
# put Fields.txt in the same directory that this .ex is in. 
# run $ elixirc FieldCleaner.ex and give the name of the collection such as "Users"
# file will be generated in a "Cleaned_Fields" directory

{:file, fileName} = {:file, "Fields.txt"}

newList =
  File.read!(fileName)
  # get rid of dollar signs
  |> String.replace(".$", "")
  # remove 1-4 digit numbers followed by colon and space
  |> String.replace(~r/(\d{1,4})(\: )/, "")
  # replace brackets for collapsed sections
  |> String.replace(~r/(\[)(.*)(\])(\n)/, "\n")
  # remove blank lines
  |> String.replace(~r/(\n)(.*)(\n)/, "\n")
  # put dash and commas at start of each line for a split character
  |> String.replace(~r/(\n)/, ",\n-:")
  # removes weird pattern
  |> String.replace(~r/(\:)(\,)(\n)/, "")
  # gets rid of colon at last line and comma ending last entry
  |> String.slice(0..-5)

# adds colon at start
newList = ":" <> newList

# split string to list on arbitrary dash
fieldList = String.split(newList, "-")
# generate length for filename purposes
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
directory = "Cleaned_Fields"
IO.puts("Cleaning Complete !")
IO.puts("#{listlen} Schema Fields Cleaned\n")
# output the cleaned list  to file
unless File.exists?(directory) do
  File.mkdir!(directory)
end

File.write(directory <> "/" <> fileOut, cleanList)

# ----------------------------------------------------------------------------------
# defmodule which cuts the list into [head|tail] and cleans each head individually then adds it to a list
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
