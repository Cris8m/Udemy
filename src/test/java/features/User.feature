@User
Feature: Validar endpoint de creacion de usuario USER
 Background:
   Given url = 'http://127.0.0.1:8900/'
   
   * headers['content-type'] = 'application/xml'
   * print headers
   * configure headers = headers


 @id:1 @ValidarResponseIsoInquiry @parallel=false
 Scenario Outline:   T-API-USER-CA1-Validar la creación de usuario
  * def payload = read('classpath:../data/requestValidation.json')
  
   Given path 'user'
   And request data
   When method POST
   Then status 200
   #* def expectedResponse = read('classpath:../../data/procesamientoIso20022/Inquiry/ExpectedResponseValidation.xml')
  # * print response
   #And match response == expectedResponse
   Examples:
    | read('classpath:../../data/procesamientoIso20022/Inquiry/ResponsesValidation.csv') |


 @id:2 @ValidarErrorCamposObligatorios @parallel=false
 Scenario Outline: T-API-PRCSMNT-2-CA2-Validar Errores en los campos Campos Obligatorios
   * print data
   * string field = <fieldXml>
   * string requestSt = data
   * print requestSt
   * xml requestXml = requestSt.replace( field ,'')
   * print requestXml
   Given url path
   And request requestXml
   When method POST
   Then status 400
   Then print <campo>
   Then print response
   #Then status 200
   #* def expectedResponse = read('classpath:../../data/procesamientoIso20022/Inquiry/ExpectedResponseValidation.xml')
   #* def responsetoXML = response.replace(xmlFileHeader, '').trim()
   #* xml responseXml = responsetoXML
   #And match responseXml == expectedResponse
   Examples:
     | read('classpath:../../data/procesamientoIso20022/Inquiry/InquiryFieldsValidation.csv') |




 @id:3 @ValidarCamposMandatoriosResponseIsoInquiry @parallel=false
 Scenario Outline: T-API-PRCSMNT-1-CA3-Validar campos mandatorios del request
   * print data
   Given url path
   And request data
   When method POST
   Then status 200
   Then print response
   Then print <campo>
   * json responseStr = response
   * print responseStr
   #* def foo = { a: 1 }* match foo.a == '#present'* match foo.nope == '#notpresent'
   #* json fieldEx = karate.jsonPath(responseStr, <fieldResponse>)
   * def fieldEx = eval('responseStr.InquiryResponseV03.' + <fieldResponse>)
   * print fieldEx
   And match fieldEx != null
   Examples:
     | read('classpath:../../data/procesamientoIso20022/Inquiry/InquiryResponseFieldsValidation.csv') |


 @id:4 @ValidarEchoInquiry @parallel=false
 Scenario Outline: T-API-PRCSMNT-2-CA4-Validar Echo Response en el Inquiry
   * print data
   Given url path
   And request data
   When method POST
   Then status 200
   * def expectedResponse = read('classpath:../../data/procesamientoIso20022/Inquiry/ExpectedResponseValidation.xml')
   * print response
   And match response == expectedResponse
   Examples:
     | read('classpath:../../data/procesamientoIso20022/Inquiry/ResponsesValidation.csv') |


