@TotalNumberOfPages
Feature: To get the books present in each page of the API

  Scenario: To get the total number of pages of all books present in the API
  Given url 'https://www.anapioficeandfire.com/api'
  And path '/books'
  When method GET
  Then status 200
  * def apiResponses = response
  * def numOfpage = karate.jsonPath(apiResponses,'$[*].numberOfPages')
  * def numfunc =
  """
   function()
   {
   var total =0
 
   for(i=0 ; i<numOfpage.length; i++)
   {
	  total += numOfpage[i]
   }
   return total
   }
  """
  * def sumOfPage1 = call numfunc
  * def pageHeader = responseHeaders['Link'][0]
  * def pages = pageHeader .split(",",3)
  * def func =
  """
   function()
   {
    for(i=0 ; i<pages.length; i++)
    {
     if(pages[i].match("next"))
     {
      return pages[i]
     }
     else{
      return 0
     }
    }
   }
  """
  * def pagenext = call func
  * def nextlink = pagenext.split(";",1)
  * def nextPageLink = nextlink[0].slice(1,nextlink.length-2)

  And url nextPageLink
  When method GET
  * def apiResponses2 = response
  * def numOfpage = karate.jsonPath(apiResponses2,'$[*].numberOfPages')
  * def sumOfPage2 = call numfunc
  * def pagination = responseHeaders['Link'][0]
  * def pages = pagination.split(",",3)
  * def nextpg = call func
  And match nextpg == 0 
  * def totalpages = sumOfPage1 + sumOfPage2
  * print "Total number of pages of all books => "+totalpages
