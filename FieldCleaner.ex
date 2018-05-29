{:file, fileName} = {:file, "Fields.txt"}

newList = File.read!(fileName)
|> String.replace(".$","")
|> String.replace(~r/(\d{2})(\: )/,"")
|> String.replace(~r/(\d{1})(\: )/,"")
|> String.replace(~r/(\n)(.*)(\n)/,"\n")
|> String.replace(~r/(\n)/,",\n")
|> String.replace(~r/(\n)/,"\n:")

listHiddenFields = ":" <> newList
listFields = String.replace(listHiddenFields, ~r/(")/,"")


IO.puts "\nField Atoms:\n"
IO.puts listFields
IO.puts "\nHidden Field Atoms:\n"
IO.puts listHiddenFields


IO.puts '''
\nDo you want to store these lists in files?
Yes: y
No: anything else
'''
userInput = IO.gets("Answer: ")


case userInput do
	"y\n" -> 
		if (File.dir?("Field_Atoms") == false) do{
			File.mkdir!("Field_Atoms")
		}
		end
		File.write("./Field_Atoms/Field_Attoms.txt", listFields)
		File.write("./Field_Atoms/Field_Attoms_Hidden.txt", listHiddenFields)
		IO.puts("File Creation Complete")

	_ -> IO.puts("No Files Created")
end
