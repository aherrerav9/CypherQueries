//EXAMPLE Uploading Doc Download Audit Report to Neo4j

LOAD CSV WITH HEADERS FROM "file:///C:\Users\aherrera\Documents\Neo4j\default.graphdb\import\PRS_DocDownload_AuditReport.csv" AS row
CREATE (n:Product)
SET n = row,
  n.unitPrice = toFloat(row.unitPrice),
  n.unitsInStock = toInteger(row.unitsInStock), n.unitsOnOrder = toInteger(row.unitsOnOrder),
  n.reorderLevel = toInteger(row.reorderLevel), n.discontinued = (row.discontinued <> "0")


//Uploading Doc Download Audit Report to Neo4j - PRS Context List
LOAD CSV WITH HEADERS FROM "file:///C:\Users\aherrera\Documents\Neo4j\default.graphdb\import\PRS_Context.csv" AS row
CREATE (n:PRS_Context)
SET 
	n = row,
	n.ID = toInteger(n.ID),
	n.Context_ID = toInteger(n.CONTEXT_ID),
	n.Context_Name = n.CONTEXT_NAME

//Uploading Doc Download Audit Report to Neo4j - Document
LOAD CSV WITH HEADERS FROM "file:///C:\Users\aherrera\Documents\Neo4j\default.graphdb\import\Documents.csv" AS row
CREATE (a:Documents)
SET 
	a = row,
	a.ID = toInteger(a.ID),
	a.Doc_ID = toInteger(a.DOCUMENT_ID),
	a.Doc_Title = toString(a.DOCUMENT_TITLE),
	a.Doc_Download_Date = toString(a.DOWNLOAD_DATE),"DD-MM-YYYY")

//Uploading Doc Download Audit Report to Neo4j - Provider
LOAD CSV WITH HEADERS FROM "file:///C:\Users\aherrera\Documents\Neo4j\default.graphdb\import\Provider.csv" AS row
CREATE (a:Provider)
SET 
	a = row,
	a.ID = toInteger(a.ID),
	a.Username = toString(a.DOWNLOAD_BY_USERNAME),
	a.User_Position = toString(a.DOWNLOAD_BY_USER_POSITION)

//Uploading Doc Download Audit Report to Neo4j - Source_Org
LOAD CSV WITH HEADERS FROM "file:///C:\Users\aherrera\Documents\Neo4j\default.graphdb\import\Source_Org.csv" AS row
CREATE (a:Source_Org)
SET 
	a = row,
	a.ID = toInteger(a.ID),
	a.Source_of_Doc = toString(a.DOCUMENTSOURCE),
	a.Source_Org = toString(a.ORGANIZATION),
	a.Source_Network = toString(a.NETWORK)


//Uploading Doc Download Audit Report to Neo4j - MedicalGroup
LOAD CSV WITH HEADERS FROM "file:///C:\Users\aherrera\Documents\Neo4j\default.graphdb\import\MedicalGroup.csv" AS row
CREATE (a:MedicalGroup)
SET 
	a = row,
	a.ID = toInteger(a.ID),
	a.MedicalGroup_Name = toString(a.MEDICAL_GROUP)

//Uploading Doc Download Audit Report to Neo4j - Department
LOAD CSV WITH HEADERS FROM "file:///C:\Users\aherrera\Documents\Neo4j\default.graphdb\import\Department.csv" AS row
CREATE (a:Department)
SET 
	a = row,
	a.ID = toInteger(a.ID),
	a.Department_Name = toString(a.DEPARTMENT)

//Uploading Doc Download Audit Report to Neo4j - Patient
LOAD CSV WITH HEADERS FROM "file:///C:\Users\aherrera\Documents\Neo4j\default.graphdb\import\Patient.csv" AS row
CREATE (a:Patient)
SET 
	a = row,
	a.ID = toInteger(a.ID),
	a.Patient_ID = toInteger(a.PATIENT_ID),
	a.Chart_ID = toInteger(a.CHART_ID)