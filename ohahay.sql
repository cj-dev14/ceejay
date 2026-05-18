CREATE DATABASE student5;
USE student5;

CREATE DATABASE IF NOT EXISTS STUDENT1;
USE STUDENT1;

-- ────────────────────────────────────────────
-- 1. PRINCIPAL
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Principal (
    PrincipalID    INT AUTO_INCREMENT PRIMARY KEY,
    FirstName      VARCHAR(50)  NOT NULL,
    MiddleName     VARCHAR(50),
    LastName       VARCHAR(50)  NOT NULL,
    Gender         ENUM('Male','Female'),
    ContactNumber  VARCHAR(15),
    Email          VARCHAR(100),
    DateAppointed  DATE
);

-- ────────────────────────────────────────────
-- 2. TEACHER
-- FIX: Department column was after AdvisorySection with a misplaced comma.
--      Corrected column order and all commas.
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Teacher (
    TeacherID           INT AUTO_INCREMENT PRIMARY KEY,
    FirstName           VARCHAR(50)  NOT NULL,
    MiddleName          VARCHAR(50),
    LastName            VARCHAR(50)  NOT NULL,
    Sex                 ENUM('Male','Female'),
    ContactNumber       VARCHAR(15),
    Department          VARCHAR(50),
    Qualification       VARCHAR(100),
    AddressBarangay     VARCHAR(100),
    AddressMunicipality VARCHAR(100),
    AddressProvince     VARCHAR(100),
    AddressPostalCode   VARCHAR(10),
    Email               VARCHAR(100),
    DateHired           DATE,
    Status              ENUM('Active','OnLeave','Resigned') DEFAULT 'Active',
    AdvisorySection     VARCHAR(50)
);

-- ────────────────────────────────────────────
-- 3. SUBJECT
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Subject (
    SubjectID     INT AUTO_INCREMENT PRIMARY KEY,
    SubjectCode   VARCHAR(10)  UNIQUE NOT NULL,
    SubjectName   VARCHAR(100) NOT NULL,
    GradeLevel    VARCHAR(10),
    Strand        VARCHAR(20),
    Semester      ENUM('1st','2nd'),
    Department    VARCHAR(50),
    ClassSchedule VARCHAR(50),
    Room          VARCHAR(10),
    TeacherID     INT,
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID)
);

-- ────────────────────────────────────────────
-- 4. STUDENT
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Student (
    StudentID               INT AUTO_INCREMENT PRIMARY KEY,
    LRN                     VARCHAR(20) UNIQUE NOT NULL,
    StudentFirstName        VARCHAR(50)  NOT NULL,
    StudentMiddleName       VARCHAR(50),
    StudentLastName         VARCHAR(50)  NOT NULL,
    GuardianFirstName       VARCHAR(50)  NOT NULL,
    GuardianMiddleName      VARCHAR(50)  NOT NULL,
    GuardianLastName        VARCHAR(50)  NOT NULL,
    Age                     TINYINT      CHECK (Age BETWEEN 1 AND 100),
    Sex                     ENUM('Male','Female'),
    Birthdate               DATE,
    PlaceOfBirthBarangay    VARCHAR(100),
    PlaceOfBirthMunicipality VARCHAR(100),
    PlaceOfBirthProvince    VARCHAR(100),
    PlaceOfBirthPostalCode  VARCHAR(10),
    Religion                VARCHAR(30),
    AddressBarangay         VARCHAR(100),
    AddressMunicipality     VARCHAR(100),
    AddressProvince         VARCHAR(100),
    AddressPostalCode       VARCHAR(10),
    EnrollmentStatus        ENUM('Active','Inactive','Transferred') DEFAULT 'Active',
    SubjectID               INT,
    TeacherID               INT,
    CONSTRAINT fk_student_subject FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID),
    CONSTRAINT fk_student_teacher FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID)
);

-- ────────────────────────────────────────────
-- 5. ADMIN
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Admin (
    AdminID             INT AUTO_INCREMENT PRIMARY KEY,
    AdminName           VARCHAR(100),
    FirstName           VARCHAR(50)  NOT NULL,
    MiddleName          VARCHAR(50),
    LastName            VARCHAR(50)  NOT NULL,
    ContactNumber       VARCHAR(15),
    EmailAddress        VARCHAR(100),
    Sex                 ENUM('Male','Female'),
    Position            VARCHAR(50),
    Department          VARCHAR(50),
    AddressBarangay     VARCHAR(100),
    AddressMunicipality VARCHAR(100),
    AddressProvince     VARCHAR(100),
    AddressPostalCode   VARCHAR(10)
);

-- ────────────────────────────────────────────
-- 6. SCHOOL YEAR
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS SchoolYear (
    SchoolYearID  INT AUTO_INCREMENT PRIMARY KEY,
    YearLabel     VARCHAR(20) UNIQUE NOT NULL,
    StartDate     DATE NOT NULL,
    EndDate       DATE NOT NULL,
    Status        ENUM('Active','Completed','Upcoming') DEFAULT 'Upcoming',
    CreatedDate   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedDate  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ────────────────────────────────────────────
-- 7. SECTION
-- FIX: Added SchoolYearID FK column (was missing from original SQL,
--      though the Java code and INSERT data both reference it).
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Section (
    SectionID   INT AUTO_INCREMENT PRIMARY KEY,
    SectionName VARCHAR(50)  NOT NULL,
    GradeLevel  VARCHAR(20)  NOT NULL,
    Adviser     VARCHAR(100) NOT NULL,
    SchoolYear  VARCHAR(20),
    SchoolYearID INT,
    FOREIGN KEY (SchoolYearID) REFERENCES SchoolYear(SchoolYearID)
);

-- ────────────────────────────────────────────
-- 8. ACADEMIC RECORD
-- FIX: Added SchoolYearID FK column (was missing from original SQL).
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS AcademicRecord (
    AcademicRecordID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID        INT,
    TeacherID        INT,
    SubjectID        INT,
    SubjectCode      VARCHAR(10),
    SubjectName      VARCHAR(100),
    Semester         ENUM('1st','2nd'),
    SchoolYear       VARCHAR(9),
    SchoolYearID     INT,
    FOREIGN KEY (StudentID)    REFERENCES Student(StudentID),
    FOREIGN KEY (TeacherID)    REFERENCES Teacher(TeacherID),
    FOREIGN KEY (SubjectID)    REFERENCES Subject(SubjectID),
    FOREIGN KEY (SchoolYearID) REFERENCES SchoolYear(SchoolYearID)
);

-- ────────────────────────────────────────────
-- 9. GRADES
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Grades (
    GradeID          INT AUTO_INCREMENT PRIMARY KEY,
    AcademicRecordID INT NOT NULL,
    Quarter1         DECIMAL(5,2),
    Quarter2         DECIMAL(5,2),
    Quarter3         DECIMAL(5,2),
    Quarter4         DECIMAL(5,2),
    FinalAverage     DECIMAL(5,2),
    Remarks          ENUM('Passed','Failed','Incomplete') DEFAULT 'Incomplete',
    FOREIGN KEY (AcademicRecordID) REFERENCES AcademicRecord(AcademicRecordID)
);

-- ────────────────────────────────────────────
-- 10. SYSTEM USER
-- FIX: Role now includes STUDENT instead of VIEWER to match Java enum.
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS SystemUser (
    UserID       INT AUTO_INCREMENT PRIMARY KEY,
    Username     VARCHAR(50)  UNIQUE NOT NULL,
    PasswordHash VARCHAR(256) NOT NULL,
    Salt         VARCHAR(64)  NOT NULL,
    Role         ENUM('ADMIN','TEACHER','STUDENT') DEFAULT 'STUDENT',
    FullName     VARCHAR(100),
    Email        VARCHAR(100),
    CreatedAt    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LastLogin    TIMESTAMP NULL
);

-- ────────────────────────────────────────────
-- 11. AUDIT LOG
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS AuditLog (
    LogID      INT AUTO_INCREMENT PRIMARY KEY,
    UserID     INT,
    Username   VARCHAR(50),
    Action     VARCHAR(20),
    TableName  VARCHAR(50),
    RecordID   VARCHAR(50),
    Details    TEXT,
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES SystemUser(UserID)
);

-- ════════════════════════════════════════════════════════════
-- SAMPLE DATA
-- ════════════════════════════════════════════════════════════

INSERT INTO SchoolYear (YearLabel, StartDate, EndDate, Status) VALUES
('2023-2024', '2023-06-05', '2024-03-29', 'Completed'),
('2024-2025', '2024-06-03', '2025-03-28', 'Active'),
('2025-2026', '2025-06-02', '2026-03-27', 'Upcoming');

INSERT INTO Principal (FirstName, MiddleName, LastName, Gender, ContactNumber, Email, DateAppointed) VALUES
('Rodrigo',  'Santos',   'Dela Cruz',  'Male',   '09171234501', 'rodrigo.delacruz@scs.edu.ph',  '2019-06-01'),
('Maricel',  'Reyes',    'Villanueva', 'Female', '09281234502', 'maricel.villanueva@scs.edu.ph', '2020-07-15'),
('Ernesto',  'Bautista', 'Magbanua',   'Male',   '09351234503', 'ernesto.magbanua@scs.edu.ph',   '2021-08-20');

INSERT INTO Teacher
    (FirstName, MiddleName, LastName, Sex, ContactNumber, Department, Qualification,
     AddressBarangay, AddressMunicipality, AddressProvince, AddressPostalCode,
     Email, DateHired, Status, AdvisorySection)
VALUES
('Lourdes',  'Cruz',   'Fernandez', 'Female', '09171110001', 'Mathematics',
 'Bachelor of Secondary Education Major in Mathematics',
 'Barangay Poblacion',               'Koronadal City', 'South Cotabato', '9506',
 'lourdes.fernandez@scs.edu.ph',  '2015-06-01', 'Active', 'Grade 11 - Rizal'),
('Ramon',    'Aquino', 'Santiago',  'Male',   '09282220002', 'Science',
 'Bachelor of Secondary Education Major in General Science',
 'Barangay Carpenter Hill',          'Koronadal City', 'South Cotabato', '9506',
 'ramon.santiago@scs.edu.ph',     '2017-06-05', 'Active', 'Grade 12 - Bonifacio'),
('Teresita', 'Gomez',  'Macaraeg',  'Female', '09393330003', 'English',
 'Bachelor of Arts in English Language',
 'Barangay General Paulino Santos',  'Koronadal City', 'South Cotabato', '9506',
 'teresita.macaraeg@scs.edu.ph',  '2018-07-10', 'Active', 'Grade 11 - Mabini');

INSERT INTO Subject (SubjectCode, SubjectName, GradeLevel, Strand, Semester, Department, ClassSchedule, Room, TeacherID) VALUES
('MATH101', 'General Mathematics',    'Grade 11', 'STEM',  '1st', 'Mathematics', 'Mon/Wed 7:30-9:00 AM',   'R101', 1),
('SCI102',  'Earth and Life Science', 'Grade 11', 'STEM',  '1st', 'Science',     'Tue/Thu 9:00-10:30 AM',  'R205', 2),
('ENG103',  'Oral Communication',     'Grade 11', 'HUMSS', '1st', 'English',     'Mon/Wed 10:30-12:00 PM', 'R308', 3);

INSERT INTO Student
    (LRN, StudentFirstName, StudentMiddleName, StudentLastName,
     GuardianFirstName, GuardianMiddleName, GuardianLastName,
     Age, Sex, Birthdate,
     PlaceOfBirthBarangay, PlaceOfBirthMunicipality, PlaceOfBirthProvince, PlaceOfBirthPostalCode,
     Religion,
     AddressBarangay, AddressMunicipality, AddressProvince, AddressPostalCode,
     EnrollmentStatus, SubjectID, TeacherID)
VALUES
('100254780001', 'Juan Miguel',   'Reyes',   'Dela Torre',
 'Roberto',  'Santos', 'Dela Torre',
 17, 'Male',   '2007-03-14',
 'Barangay Poblacion',              'Koronadal City', 'South Cotabato', '9506',
 'Roman Catholic',
 'Barangay Namnama',                'Koronadal City', 'South Cotabato', '9506',
 'Active', 1, 1),
('100254780002', 'Maria Kristina', 'Lim',     'Bautista',
 'Eduardo',  'Cruz',   'Bautista',
 16, 'Female', '2008-07-22',
 'Barangay Assumption',             'Koronadal City', 'South Cotabato', '9506',
 'Roman Catholic',
 'Barangay Carpenter Hill',         'Koronadal City', 'South Cotabato', '9506',
 'Active', 2, 2),
('100254780003', 'Jose Antonio',   'Mendoza', 'Villaluz',
 'Corazon',  'Ramos',  'Villaluz',
 17, 'Male',   '2007-11-05',
 'Barangay Zone IV',                       'Koronadal City', 'South Cotabato', '9506',
 'Iglesia ni Cristo',
 'Barangay General Paulino Santos',        'Koronadal City', 'South Cotabato', '9506',
 'Active', 3, 3);

INSERT INTO Admin
    (AdminName, FirstName, MiddleName, LastName,
     ContactNumber, EmailAddress, Sex, Position, Department,
     AddressBarangay, AddressMunicipality, AddressProvince, AddressPostalCode)
VALUES
('admin_gabutan',    'Nestor', 'Pacardo', 'Gabutan',
 '09174440001', 'nestor.gabutan@scs.edu.ph',    'Male',   'School Registrar',   'Administrative',
 'Barangay Zone II', 'Koronadal City', 'South Cotabato', '9506'),
('admin_salvador',   'Glenda', 'Ybanez',  'Salvador',
 '09285550002', 'glenda.salvador@scs.edu.ph',   'Female', 'Guidance Counselor', 'Student Affairs',
 'Barangay Mabini',  'Koronadal City', 'South Cotabato', '9506'),
('admin_buenaflor',  'Danilo', 'Liwanag', 'Buenaflor',
 '09396660003', 'danilo.buenaflor@scs.edu.ph',  'Male',   'IT Administrator',   'Information Technology',
 'Barangay Paraiso', 'Koronadal City', 'South Cotabato', '9506');

INSERT INTO Section (SectionName, GradeLevel, Adviser, SchoolYear, SchoolYearID) VALUES
('Rizal',     'Grade 11', 'Lourdes Fernandez', '2024-2025', 2),
('Bonifacio', 'Grade 12', 'Ramon Santiago',    '2024-2025', 2),
('Mabini',    'Grade 11', 'Teresita Macaraeg', '2024-2025', 2);

INSERT INTO AcademicRecord (StudentID, TeacherID, SubjectID, SubjectCode, SubjectName, Semester, SchoolYear, SchoolYearID) VALUES
(1, 1, 1, 'MATH101', 'General Mathematics',    '1st', '2024-2025', 2),
(2, 2, 2, 'SCI102',  'Earth and Life Science', '1st', '2024-2025', 2),
(3, 3, 3, 'ENG103',  'Oral Communication',     '1st', '2024-2025', 2);

INSERT INTO Grades (AcademicRecordID, Quarter1, Quarter2, Quarter3, Quarter4, FinalAverage, Remarks) VALUES
(1, 88.00, 91.00, 85.00, 90.00, 88.50, 'Passed'),
(2, 75.00, 78.00, 72.00, 80.00, 76.25, 'Passed'),
(3, 65.00, 70.00, 68.00, 72.00, 68.75, 'Failed');

-- NOTE: The PasswordHash values below are PLACEHOLDERS only.
-- The Java app uses PBKDF2-SHA256 at runtime. On first startup,
-- it auto-seeds an ADMIN account with username="admin" / password="admin123".
-- Use the Register button to create TEACHER and STUDENT accounts properly.
INSERT INTO SystemUser (Username, PasswordHash, Salt, Role, FullName, Email) VALUES
('admin',
 'placeholder_will_be_replaced_on_first_login',
 'placeholder_salt',
 'ADMIN',   'System Administrator',          'admin@scs.edu.ph'),
('teacher_fernandez',
 'placeholder_will_be_replaced_on_first_login',
 'placeholder_salt',
 'TEACHER', 'Lourdes Fernandez',             'lourdes.fernandez@scs.edu.ph'),
('student_reyes',
 'placeholder_will_be_replaced_on_first_login',
 'placeholder_salt',
 'STUDENT', 'Maria Kristina Lim Bautista',   'student.reyes@scs.edu.ph');