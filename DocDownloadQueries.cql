//EXAMPLE QUERY - Uploading Doc Download Audit Report to Neo4j

LOAD CSV WITH HEADERS FROM "file:///PRS_DocDownload_AuditReport.csv" AS row
CREATE (n:Product)
SET n = row,
  n.unitPrice = toFloat(row.unitPrice),
  n.unitsInStock = toInteger(row.unitsInStock), n.unitsOnOrder = toInteger(row.unitsOnOrder),
  n.reorderLevel = toInteger(row.reorderLevel), n.discontinued = (row.discontinued <> "0")


//Uploading Doc Download Audit Report to Neo4j - PRS Context List
LOAD CSV WITH HEADERS FROM "file:///PRS_Context.csv" AS row
CREATE (n:PRS_Context)
SET 
	n = row,
	n.ID = toInteger(row.ID),
	n.Context_ID = toInteger(row.CONTEXT_ID),
	n.Context_Name = row.CONTEXT_NAME

//Uploading Doc Download Audit Report to Neo4j - Document
LOAD CSV WITH HEADERS FROM "file:///Documents.csv" AS row
CREATE (a:Documents)
SET 
	a = row,
	a.ID = toInteger(row.ID),
	a.Doc_ID = toInteger(row.DOCUMENT_ID),
	a.Doc_Title = toString(row.DOCUMENT_TITLE),
	a.Doc_Download_Date = row.DOWNLOAD_DATE

//Uploading Doc Download Audit Report to Neo4j - Provider
LOAD CSV WITH HEADERS FROM "file:///Provider.csv" AS row
CREATE (a:Provider)
SET 
	a = row,
	a.ID = toInteger(row.ID),
	a.Username = toString(row.DOWNLOAD_BY_USERNAME),
	a.User_Position = toString(row.DOWNLOAD_BY_USER_POSITION)

//Uploading Doc Download Audit Report to Neo4j - Source_Org
LOAD CSV WITH HEADERS FROM "file:///Source_Org.csv" AS row
CREATE (a:Source_Org)
SET 
	a = row,
	a.ID = toInteger(row.ID),
	a.Source_of_Doc = toString(row.DOCUMENTSOURCE),
	a.Source_Org = toString(row.ORGANIZATION),
	a.Source_Network = toString(row.NETWORK)


//Uploading Doc Download Audit Report to Neo4j - MedicalGroup
LOAD CSV WITH HEADERS FROM "file:///MedicalGroup.csv" AS row
CREATE (a:MedicalGroup)
SET 
	a = row,
	a.ID = toInteger(row.ID),
	a.MedicalGroup_Name = toString(row.MEDICAL_GROUP)

//Uploading Doc Download Audit Report to Neo4j - Department
LOAD CSV WITH HEADERS FROM "file:///Department.csv" AS row
CREATE (a:Department)
SET 
	a = row,
	a.ID = toInteger(row.ID),
	a.Department_Name = toString(row.DEPARTMENT)

//Uploading Doc Download Audit Report to Neo4j - Patient
LOAD CSV WITH HEADERS FROM "file:///Patient.csv" AS row
CREATE (a:Patient)
SET 
	a = row,
	a.ID = toInteger(row.ID),
	a.Patient_ID = toInteger(row.PATIENT_ID),
	a.Chart_ID = toInteger(row.CHART_ID)

//Creating Indexes

CREATE INDEX ON :PRS_Context(ID)

CREATE INDEX ON :Documents(ID)

CREATE INDEX ON :Provider(ID)

CREATE INDEX ON :Source_Org(ID)

CREATE INDEX ON :MedicalGroup(ID)

CREATE INDEX ON :Department(ID)

CREATE INDEX ON :Patient(ID)

//Creating Data Relationships 