Attribute VB_Name = "RESTfulAPI"

'***********************************************************************
'** 20170926 Jake
'** RESTful API GET
'get select sql excuting result from url by GET.
'Input:url,sql output: sql excuting result
'if you want to get a lot of data, please use this Function
'***********************************************************************
Function QuerySQLExcute(ByVal target_url As String, ByVal sql As String) As String
    'Dim objSC, objJSON  As Object
    'Dim strFunc, strJSON As String
    'Set objSC = CreateObject("ScriptControl")
    'objSC.Language = "JScript"
    'strFunc = "function jsonParse(s) { return eval('(' + s + ')'); }"
    'objSC.AddCode strFunc
    
    If target_url = "" Then
       Exit Function
    End If
    
    If sql <> "" Then
       target_url = target_url & encodeURI("?sql=" & sql & "&form=csv")
    End If

    
    Set httpObj = CreateObject("MSXML2.XMLHTTP")

    If httpObj Is Nothing Then
       MsgBox "XMLHTTP Creat error", vbCritical
       Exit Function
     End If

    target_url = Replace(target_url, "%25", "%")
    target_url = Replace(target_url, "%0A", "")
    
    
    httpObj.Open "GET", target_url, False
    Call httpObj.setRequestHeader("Content-Type", "application/text")
    Call httpObj.setRequestHeader("If-Modified-Since", "Thu, 01 Jun 0000 00:00:00 GMT")
    httpObj.send ("")
    
    If httpObj.Status = 200 Then
       Debug.Print "Web API GET 正常に終了しました"
    Else
       MsgBox "[StatusCode:" & httpObj.Status & "]:異常に終了しました"
       QuerySQLExcute = ""
       Exit Function
    End If
    
    If httpObj.ResponseText = "" Then
       MsgBox "データが存在しません"
       Exit Function
    End If

    QuerySQLExcute = httpObj.ResponseText
    
End Function

'********************************************************************************
'** 20170926 by Jake
'** RESTful API POST
' POST 1 sql by url to excute of insert or delete.
'Input:url,sql output: sql excuting result
'if you want to send one data, please use this Function
'********************************************************************************

Function postSQLbyURL(ByVal target_url As String, ByVal sql As String) As String
    'target_url = "http://localhost:9090/db/insert" & encodeURI("?sql=" & sql)
    target_url = target_url & encodeURI("?sql=" & sql)
    sendData = sql

    Set httpObj = CreateObject("MSXML2.XMLHTTP")

    httpObj.Open "POST", target_url, True  'True=異歩
    
    'Call httpObj.setRequestHeader("Content-Type", "application/text")
    Call httpObj.setRequestHeader("Content-Type", "text/plain;charset=utf-8")
    Call httpObj.setRequestHeader("If-Modified-Since", "Thu, 01 Jun 0000 00:00:00 GMT")
    httpObj.send (sendData)
    
    Do Until httpObj.ReadyState = 4
       DoEvents
    Loop

    
    strResponse = httpObj.ResponseText
 
    If httpObj.Status = 200 Then
       Debug.Print strResponse & "件が成功に処理しました"
       postSQLbyURL = strResponse
    Else
       MsgBox "[StatusCode:" & httpObj.Status & "]異常に終了しました"
       strResponse = "-1"
    End If
    
End Function

'********************************************************************************
'** 20170926 by Jake
'** RESTful API POST
' POST insert data(JSON) to url, to excute DB insert.
'Input:url,JSON data, output: count of successfully excuting
'if you want to send a lot of data, please use this Function
'but you must know the target table, and put the table name in URL
'for example, target_url ="http://localhost:9090/db/resources/adds"
'********************************************************************************

Function postSQLbyBody(ByVal target_url As String, ByVal sendData As String) As String
   Set httpObj = CreateObject("MSXML2.XMLHTTP")
  
    httpObj.Open "POST", target_url, True  'True=異歩
    Call httpObj.setRequestHeader("Content-Type", "application/json;charset=utf-8")
    Call httpObj.setRequestHeader("If-Modified-Since", "Thu, 01 Jun 0000 00:00:00 GMT")
    
    httpObj.send (sendData)
    
    Do Until httpObj.ReadyState = 4
       DoEvents
    Loop

    strResponse = httpObj.ResponseText
 
    If httpObj.Status = 200 Then
       Debug.Print "httpObj.ResponseText=" & strResponse

    Else
       Debug.Print "[StatusCode:" & httpObj.Status & "]異常に終了しました"
       strResponse = "-1"
    End If
    postSQLbyBody = strResponse
End Function

'JSON配列分割してSendする

Function splitSend(ByVal target_url As String, ByVal sendData As String) As Integer
    Dim arry_result1() As String
    Dim arry_result2() As String
    
    sendData = Replace(sendData, "[", "")
    sendData = Replace(sendData, "]", "")
    
    fstr = "},{"
    rstr = "}" & Chr(10) & "{"
    sendData = Replace(sendData, fstr, rstr)
    arry_result1 = Split(sendData, Chr(10))
    
    i = 0
    arry_result2(0) = "["
    
    For Each result1 In arry_result1
    
      If arry_result2(i) = "[" Then
         arry_result2(i) = arry_result2(i) & result1
      Else
         arry_result2(i) = arry_result2(i) & "," & result1
      End If
      
    '500件send 1回
      If i = 500 Then
         arry_result2 (i) & "]"
         rs = postSQLbyBody(target_url, arry_result2(i))
      End If
      
      i = i + 1
      arry_result2(i) = "["
    
    Next
    
End Function

Function DecodeURI(ByVal strText As String) As Variant

    Dim js

    Set js = CreateObject("msscriptcontrol.scriptcontrol")

    js.Language = "JavaScript"

    'UrlDecode = js.eval("decodeURI('" & strText & "');") '忽略! @ # $ & * ( ) = : / ;   + '

    'UrlEncode = js.Eval("escape('" & Replace(strText, "'", "\'") & "');") '漢字⇒%uXX的Unicode 無視： @ * / +

    UrlDecode = js.Eval("decodeURIComponent('" & strText & "');") '包含://

End Function

Function encodeURI(ByVal strText As String) As String
    strText = Replace(strText, "", "\")
    strText = Replace(strText, "'", "\'")
    strText = Replace(strText, Chr(13), "")
    strText = Replace(strText, Chr(10), "")
    strText = Replace(strText, Chr(0), "\0")

    With CreateObject("msscriptcontrol.scriptcontrol")
        .Language = "JavaScript"
        'encodeURI = .Eval("encodeURIComponent('" & strText & "');")
        encodeURI = .Eval("encodeURI('" & strText & "');")
    End With
    
    
End Function
Sub encodeURITest()

  arr = Array("%", "<", ">", "'", "=", "&")
  
  Dim out As String
  
  out = ""

  For Each a In arr
   out = out & Chr(13) & a & "     :    " & encodeURI(a)
  Next
  
  MsgBox (out)
  
  str1 = "select * from workschedule where Workdate='20170920' and name ='jake.jian.wang'" & "&form=csv"
  MsgBox (encodeURI(str1))
  
End Sub


