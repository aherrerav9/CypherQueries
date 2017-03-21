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

//Uploading Doc Download Audit Report to Neo4j - Documents
LOAD CSV WITH HEADERS FROM "file:///Documents.csv" AS row
CREATE (a:Documents)
SET 
	a = row,
	a.ID = toInteger(row.ID),
	a.Doc_ID = toInteger(row.Documents_ID),
	a.Doc_Title = toString(row.Documents_TITLE),
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
	a.Source_of_Doc = toString(row.DocumentsOURCE),
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

//PRS_Context to Documents
MATCH (c:PRS_Context),(d:Documents)
WHERE c.ID = d.ID
MERGE (c)-[r:DOWNLOADS]->(d)
RETURN c, r, d
LIMIT 10

//Documents to Source_Org
MATCH (d:Documents),(s:Source_Org)
WHERE d.ID = s.ID
MERGE (d)-[r:UPLOADED_BY]->(s)
RETURN d, r, s
LIMIT 10

//Documents to Patient
MATCH (d:Documents),(p:Patient)
WHERE d.ID = p.ID
MERGE (d)-[r:ABOUT]->(p)
RETURN d, r, p
LIMIT 10

//Documents to Provider
MATCH (d:Documents),(p:Provider)
WHERE d.ID = p.ID
MERGE (d)-[r:DOWNLOADED_BY]->(p)
RETURN d, r, p
LIMIT 10

//Patient to Department
MATCH (p:Patient),(d:Department)
WHERE p.ID = d.ID
MERGE (p)-[r:RECEIVED_CARE_AT]->(d)
RETURN p, r, d
LIMIT 10

//Department to Medical Group
MATCH (d:Department), (m:MedicalGroup)
WHERE d.ID = m.ID
MERGE (d)-[r:PART_OF]->(m)
RETURN d, r, m
LIMIT 10

//MedicalGroup to PRS_Context
MATCH (m:MedicalGroup),(c:PRS_Context)
WHERE m.ID = c.ID
MERGE (m)-[r:PART_OF]->(c)
RETURN m, r, c
LIMIT 10

//Provider to PRS_Context
MATCH (p:Provider),(c:PRS_Context)
WHERE p.ID = c.ID
MERGE (p)-[r:EMPLOYED_BY]->(c)
RETURN p, r, c
LIMIT 10

//Checking our bases
//WHAT IS THE SCHEMA - aka what's related and how is it related?
CALL db.schema()

//Node labels
CALL db.labels()

//relationship types
CALL db.relationshipTypes()

//Display constraints and indexes
//Constraint - helps with data integrity by ensuring uniqueness of certain properties on nodes with specific labels
///adding constraints implicitly add an index on the property, so don't need to do it separately
//Index - add it to help the graph DB find the starting point as quickly as possible (don't necessarily need it)
:schema


//Understanding things about the data
//Counting nodes
MATCH (n)
RETURN count(n)

//Count all relationships
MATCH ()-->()
RETURN count(*);

//What kinds of nodes exist? What kinds of properties and relationships exist for some of nodes
//Get lay of the land

MATCH (n) 
WHERE rand() <= 0.1 //This samples 10% of total amount of records
RETURN
DISTINCT labels(n),
count(*) AS SampleSize,
avg(size(keys(n))) as Avg_PropertyCount, //keys returns info about properties
min(size(keys(n))) as Min_PropertyCount,
max(size(keys(n))) as Max_PropertyCount,
avg(size( (n)-[]-() ) ) as Avg_RelationshipCount,
min(size( (n)-[]-() ) ) as Min_RelationshipCount,
max(size( (n)-[]-() ) ) as Max_RelationshipCount

MATCH (n)
WHERE rand() <= 0.1 
RETURN
	DISTINCT labels(),
	count (*) AS SampleSize,
	avg(size(keys(n))) as Avg_PropertyCount,
	min(size(keys(n))) as Min_PropertyCount,
	max(size(keys(n))) as Max_PropertyCount,
	avg(size( (n)-[]-() ) ) as Avg_RelationshipCount,
	min(size( (n)-[]-() ) ) as Min_RelationshipCount,
	max(size( (n)-[]-() ) ) as Max_RelationshipCount


//Query - show relatedness of doctors (eg who are the doctors pulling docs from same place)

//Recommend - help parse signal from noise with documents we show PRS user aka put relevant docs it at the top of the bucket of documents to download
//Look at info on document (source, organization, network) and geographic area (aka if context is in area with more CQ or CQ) - eg feed CQ documents to providers in CQ-dense area
//if we used FHIR-based CCDA docs, we could get more granular (aka determine if docs are blank or not) AND then spit out documents with the most relevant sections
//eg patient, allergies, meds, problem list, etc.. but it would show as most basic unit of transaction

//Shortest Path