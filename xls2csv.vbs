Dim srcPath
Dim outPath

Set args = WScript.Arguments
for i = 0 to args.Count - 1
    if(args(i) = "-h") Then 
        WScript.Echo("convert xls to csv")
    elseif(args(i) = "-d") Then
        i = i+1
        srcPath = args(i)
    End if
next

count = SaveToCSVs(srcPath, srcPath & "\tmp")
wscript.Echo("convert " & count & " files")


'===============================================
'   Sub && Functions
Function SaveToCSVs(srcPath, outPath)
    Dim wB 'As Workbook
    Dim wS 'As Worksheet
    Dim fPath 'As String
    Dim sPath 'As String
    Dim outName
    Dim fileCount

    Set fsObj = WScript.CreateObject("scripting.filesystemObject")
    Set srcDir = fsobj.getfolder(srcPath)
    Set excelObj = WScript.CreateObject("Excel.Application")

    if(fsObj.folderExists(outPath)) then
        outDir = fsObj.getfolder(outPath)
    else
        outDir = fsobj.createFolder(outPath)
    end if

    fileCount = 0

    excelObj.DisplayAlerts = false
    for each file in srcDir.files
        If Right(file, 4) = ".xls" Or Right(file, 5) = ".xlsx" Then
            On Error Resume Next
            Set wB = excelObj.Workbooks.open(srcDir + "\" + file.name)
            wscript.echo("copying " & srcDir + "\" & file.name  &" to csv files")
            sheet_num = 1
            for each ws in wb.sheets

                if(Right(file, 4) = ".xls") then
                    wb_name = Left(wb.name, len(wb.name)-4)
                else 
                    wb_name = Left(wb.name, len(wb.name)-5)
                end if

                outName = outDir & "\" & wb_name & "_" & sheet_num &".csv"
                call ws.SaveAs(outName, 6)
                fileCount = fileCount + 1
            next
            wb.Application.quit()
            set wb = Nothing
        End if
    next

    SaveToCSVs = fileCount
End Function
