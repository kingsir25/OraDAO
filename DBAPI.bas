Attribute VB_Name = "DBAPI"
Sub Test()
 str1 = ThisWorkbook.Sheets("sql").Cells(20, 2).Value
 MsgBox (str1)
 Ln = InStr(1, str1, Chr(10))
 MsgBox (Ln)
 arr = Split(str1, Chr(10))
 MsgBox (arr(0))
 MsgBox (arr(1))
 
End Sub
Sub Request_HTTP()
    Dim StrAction As String
    
    If Range("I1").Value <> "" Then
      StrAction = Range("I1").Value
      
      Select Case StrAction
      Case "POST"
            Call POST_HTTP
      Case "GET"
            Call GET_HTTP
      Case Else
          MsgBox ("Action select error")
      End Select
    End If
    
End Sub

Sub RESTfulGetCsv()

    Dim sql As String 'input
    Dim csv As String 'output
    Dim arry_sql() As String
    Dim arry_result1() As String
    Dim arry_result2() As String

    
    sql = ThisWorkbook.Sheets("sql excute").Range("A1").Value
    
    arry_sql = Split(sql, " ")
    
    If Trim(arry_sql(0)) <> "select" Then
      MsgBox ("please input select sql")
      Exit Sub
    End If
    'sql = Replace(sql, " ", "%20")
    'Array counts =UBound(arry_result1)+1
    '行数 = Len(csv) - Len(Replace(csv, chr(13), ""))

    '↓**URL地址↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    'target_url = "http://localhost:9090/db/query"
    target_url = ThisWorkbook.Sheets("sql excute").Range("J1").Value & "/db/query"
    '↑**URL地址↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
    
   
    csv = RESTfulAPI.QuerySQLExcute(target_url, sql)
    If csv = "" Then Exit Sub
    
    csv = Replace(csv, "<pre>", "")      '標識削除する
    csv = Replace(csv, "</pre>", "")     '標識削除する
    csv = Trim(csv)
    
    
    '行分割chr(13) chr(10)
    arry_result1 = Split(csv, Chr(10))
    
    
    
     i = 20
    For Each result1 In arry_result1
    '列分割
       j = 1
      arry_result2 = Split(result1, ",")

      For Each result2 In arry_result2
       ThisWorkbook.Sheets("sql excute").Cells(i, j).Value = Replace(result2, """", "")
       j = j + 1
      Next
      i = i + 1
    Next
    
End Sub
Sub RESTfulPostSQL()

 Dim sql As String 'input
 Dim result As String 'output
 result = "0"
    sql = ThisWorkbook.Sheets("sql excute").Range("A1").Value
    arry_sql = Split(sql, " ")
    
    If Trim(arry_sql(0)) <> "insert" And Trim(arry_sql(0)) <> "delete" Then
      MsgBox ("please input insert or delete sql")
      Exit Sub
    End If
    
    '↓**URL地址↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    'target_url = "http://localhost:9090/db/insert"
    target_url = ThisWorkbook.Sheets("sql excute").Range("J1").Value & "/db/insert"
    '↑**URL地址↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
    result = RESTfulAPI.postSQLbyURL(target_url, sql)
    MsgBox result & "件が成功に処理されました"
    
    
End Sub

Sub GET_HTTP()

' get parameter

    Dim StrURL As String
    Dim StrP1, StrP2, sql As String
    
    If Range("I2").Value <> "" Then
    StrURL = Range("I2").Value
    Else
      MsgBox ("URL = null")
      Exit Sub
    End If
    
    If Range("I3").Value <> "" Then
    StrURL = StrURL & "/" & Range("I3").Value
    End If
    
    If Range("I4").Value <> "" Then
    StrURL = StrURL & "/" & Range("I4").Value
    End If
    
    If Range("I5").Value <> "" Then
    StrURL = StrURL & "?sql=" & Range("I5").Value
    End If
    
    Dim objSC   As Object
    Dim strFunc As String
    Dim strJSON As String
    Dim objJSON As Object

    Dim n As Integer

    Set objSC = CreateObject("ScriptControl")
    objSC.Language = "JScript"
    strFunc = "function jsonParse(s) { return eval('(' + s + ')'); }"
    objSC.AddCode strFunc

    target_url = StrURL
   
    sendData = ""

    Set httpObj = CreateObject("MSXML2.XMLHTTP")

    If httpObj Is Nothing Then
       MsgBox "XMLHTTP オブジェクトを作成できませんでした。", vbCritical
       Exit Sub
     End If
 
    httpObj.Open "GET", target_url, False

    Call httpObj.setRequestHeader("Content-Type", "application/text")
    Call httpObj.setRequestHeader("If-Modified-Since", "Thu, 01 Jun 0000 00:00:00 GMT")
    
    httpObj.send (sendData)

    strJSON = httpObj.ResponseText
    
   If strJSON = "" Then
       MsgBox "Key=" & strID & "のデータが存在しません"
       Exit Sub
    End If
    
    Set objJSON = objSC.codeobject.jsonParse(httpObj.ResponseText)
    
    With ThisWorkbook.Sheets("result")
    
    If Mid(strJSON, 1, 1) = "[" Then
       n = 3
       For Each jItem In objJSON

            .Cells(n, 1).Value = CallByName(jItem, .Cells(2, 1).Value, VbGet)
            .Cells(n, 2).Value = CallByName(jItem, .Cells(2, 2).Value, VbGet)
            .Cells(n, 3).Value = CallByName(jItem, .Cells(2, 3).Value, VbGet)
            .Cells(n, 4).Value = CallByName(jItem, .Cells(2, 4).Value, VbGet)
            .Cells(n, 5).Value = CallByName(jItem, .Cells(2, 5).Value, VbGet)
            n = n + 1
       Next
    Else
    
        .Range("A2").Value = CallByName(objJSON, .Cells(2, 1).Value, VbGet)
        .Range("B2").Value = CallByName(objJSON, .Cells(2, 2).Value, VbGet)
        .Range("C2").Value = CallByName(objJSON, .Cells(2, 3).Value, VbGet)
        .Range("D2").Value = CallByName(objJSON, .Cells(2, 4).Value, VbGet)
        .Range("E2").Value = CallByName(objJSON, .Cells(2, 5).Value, VbGet)
    End If
    
    End With
    
    
End Sub
Sub POST_HTTP()

' get parameter

    Dim target_url As String
    Dim StrP1, StrP2, sql As String
    Dim n As Integer
    
    If Range("I2").Value <> "" Then
    StrURL = Range("I2").Value
    Else
      MsgBox ("URL = null")
      Exit Sub
    End If
    
    If Range("I3").Value <> "" Then
    StrURL = StrURL & "/" & Range("I3").Value
    End If
    
    If Range("I4").Value <> "" Then
    StrURL = StrURL & "/" & Range("I4").Value
    End If
    
    sendData = Range("I5").Value
    
    Set httpObj = CreateObject("MSXML2.XMLHTTP")

    target_url = StrURL
    httpObj.Open "POST", target_url, False

    Call httpObj.setRequestHeader("Content-Type", "application/text")
    
    httpObj.send (sendData)

    strResponse = httpObj.ResponseText
    
    If httpObj.Status = 200 Then
       MsgBox "正常に終了しました"
    Else
       MsgBox "[StatusCode:" & httpObj.Status & "]strResponse:異常に終了しました"
    End If


End Sub
Function parameter_check() As Boolean
    If Range("I2").Value <> "" Then
    StrURL = Range("I2").Value
    Else
      MsgBox ("URL = null")
      ReturnValue = False
    End If
    
    If Range("I2").Value <> "" Then
    StrURL = Range("I2").Value
    Else
      MsgBox ("URL = null")
      ReturnValue = False
    End If

End Function
