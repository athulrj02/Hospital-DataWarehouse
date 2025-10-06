USE DW_hospital;
GO

-- 1. Patient Dimension
CREATE TABLE Patient_Dim
(
    PatientID VARCHAR(20) PRIMARY KEY,
    PatientGender VARCHAR(10),
    PatientBirthOfDate DATE,
    PatientRace VARCHAR(50),
    PatientMaritalStatus VARCHAR(50),
    PatientLanguage VARCHAR(50),
    PatientPopulationPercentageBelowPoverty DECIMAL(5,2)
)
GO

-- 2. Diagnosis Dimension
CREATE TABLE Diagnosis_Dim
(
    DiagnosisID INT PRIMARY KEY IDENTITY(1,1),
	PatientID VARCHAR(20),
    PrimaryDiagnosisCode VARCHAR(255),
    PrimaryDiagnosisDescription VARCHAR(255),
	DoctorName VARCHAR(100)
)
GO

-- 3. Date Dimension
CREATE TABLE Date_Dim
(
    AdmissionID VARCHAR(20) PRIMARY KEY,
	PatientID VARCHAR(20),
    AdmissionStartDate DATE,
    AdmissionEndDate DATE
);
GO

-- 4. Doctor Dimension
CREATE TABLE Doctor_Dim
(
    DoctorID INT PRIMARY KEY,
	PatientID VARCHAR(20),
    DoctorName VARCHAR(100),
    MedicalDepartment VARCHAR(100)
);
GO

-- ✅ Fact Table
CREATE TABLE Admission_Fact
(
    PatientID VARCHAR(20),
    DiagnosisID INT,
    AdmissionID VARCHAR(20),
    DoctorID INT,
    AdmissionStartDate DATE,
    AdmissionEndDate DATE,
    PRIMARY KEY (PatientID, DiagnosisID, DoctorID, AdmissionID),
    FOREIGN KEY (PatientID) REFERENCES Patient_Dim(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor_Dim(DoctorID),
    FOREIGN KEY (AdmissionID) REFERENCES Date_Dim(AdmissionID), 
    FOREIGN KEY (DiagnosisID) REFERENCES Diagnosis_Dim(DiagnosisID)
)
GO
