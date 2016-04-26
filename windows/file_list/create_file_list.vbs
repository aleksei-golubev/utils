dim path, isPlain

isPlain = false

if WScript.Arguments.Count > 0 then 
	if WScript.Arguments(0) = "-p" then isPlain = true
end if

if WScript.Arguments.Count < 2 then
    path = "."
else 
	path = WScript.Arguments(1)
end if

set fso = CreateObject("Scripting.FileSystemObject")

function fileList (dir_path)
	dim content, linkCode, br
	
	if not isPlain then content = "<div style='margin-left:5px;'>" & chr(10) & chr(13)
	
	if fso.FolderExists(dir_path) then
		set fld = fso.GetFolder(dir_path)
		set files = fld.Files
		
		br = ""
		
		for each f in files
			if isPlain then
				content = dir_path & "\" & f.name & chr(10) & chr(13)
			else
				linkCode = "<a href='" & dir_path & "\" & f.name & "'>" & dir_path & "\" & f.name & "</a>"
				content = content & br & linkCode & chr(10) & chr(13)
				br = "<br/>"
			end if
		next
		
		if WScript.Arguments.Count > 2 then
			if WScript.Arguments(2) = "-s" then
				set subFolders = fld.SubFolders
				
				for each sf in subFolders
					if isPlain then
						content = content & dir_path & "\" & sf.name & "\" & chr(10) & chr(13)
					else
						linkCode = "<a href='" & dir_path & "\" & sf.name & "\'>" & dir_path & "\" & sf.name & "\</a>"
						content = content & br & linkCode & chr(10) & chr(13)
					end if
					
					if WScript.Arguments.Count > 3 then
						if WScript.Arguments(3) = "-r" then
							content = content & br & fileList(dir_path & "\" & sf.name) & chr(10) & chr(13)
						end if
					end if
				next
			end if
		end if
	else
		WScript.Echo "Path """ & path & """ doesn't exist."
	end if
	
	if not isPlain then content = content & "</div>"
	
	fileList = content
end function

if not isPlain then
	Set fList = fso.CreateTextFile("file_list.html", True)
	fList.WriteLine("<html>")
	fList.Write("<head><title>" & path & "</title></head>")
	fList.WriteLine("<body>")
	fList.WriteLine(fileList(path))
	fList.WriteLine("</body>")
	fList.WriteLine("</html>")
	fList.Close
else
	Set fList = fso.CreateTextFile("file_list.txt", True)
	fList.WriteLine(fileList(path))
end if