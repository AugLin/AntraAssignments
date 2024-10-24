CREATE TABLE Movies (
    Id INT PRIMARY KEY,
    BackdropUrl VARCHAR(2084),
    Budget DECIMAL(18,4),
    CreatedBy VARCHAR(MAX),
    ImdbUrl VARCHAR(2084),
    OriginalLanguage VARCHAR(64),
    Overview VARCHAR(MAX),
    PosterUrl VARCHAR(2084),
    Price Decimal(5, 2),
    ReleaseDate DATETIME2,
    Revenue DECIMAL(18, 4),
    RunTime INT,
    Tagline VARCHAR(512),
    Title VARCHAR(256),
    TmdbUrl VARCHAR(2084),
    UpdatedBy VARCHAR(MAX),
    UpdateDate DATETIME2
);

CREATE TABLE Genres(
    Id INT PRIMARY KEY,
    Name VARCHAR(24) NOT NULL,
)

CREATE TABLE MovieGenres(
    GenreId INT NOT NULL ,
    MovieId INT NOT NULL,
    PRIMARY KEY (GenreId, MovieId),
    FOREIGN KEY (GenreId) REFERENCES Genres(Id),
    FOREIGN KEY (MovieId) REFERENCES Movies(Id)
)

CREATE TABLE Casts(
    Id INT PRIMARY KEY,
    Gender VARCHAR(MAX) NOT NULL,
    NAME VARCHAR(128) NOT NULL,
    ProfilePath VARCHAR(2084) NOT NULL,
    TmdbUrl VARCHAR(MAX) NOT NULL
)

CREATE TABLE MovieCasts(
    CastId INT NOT NULL,
    Character VARCHAR(450) NOT NULL,
    MovieId INT NOT NULL,
    PRIMARY KEY (CastId, Character, MovieId),
    FOREIGN KEY (CastId) REFERENCES Casts(Id),
    FOREIGN KEY (MovieId) REFERENCES Movies(Id)
)

CREATE TABLE Trailers (
    Id INT NOT NULL PRIMARY KEY,
    MovieId INT NOT NULL,
    Name VARCHAR(2084) NOT NULL,
    TrailerUrl VARCHAR(2084) NOT NULL,
    FOREIGN KEY(MovieId) REFERENCES Movies(Id)
)

CREATE TABLE Users(
    Id INT PRIMARY KEY,
    DateOfBirth DATETIME2,
    Email VARCHAR(256) NOT NULL,
    FirstName VARCHAR(128) NOT NULL,
    HashedPassword VARCHAR(1024) NOT NULL,
    IsLocked BIT,
    LastName VARCHAR(128) NOT NULL,
    PhoneNumber VARCHAR(16),
    ProfilePictureUrl VARCHAR(Max),
    Salt VARCHAR(1024) NOT NULL
)

CREATE TABLE Favorites (
    MovieId INT NOT NULL,
    UserId INT NOT NULL,
    PRIMARY KEY (MovieId, UserId),
    FOREIGN KEY (MovieId) REFERENCES Movies(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
)

CREATE TABLE Reviews (
    MovieId INT,
    UserId INT,
    CreatedDate DATETIME2 NOT NULL,
    Rating DECIMAL(3,2) NOT NULL,
    ReviewText VARCHAR(MAX) NOT NULL,
    PRIMARY KEY (MovieId, UserId),
    Foreign KEY(MovieId) REFERENCES Movies(Id),
    Foreign KEY(UserId) REFERENCES Users(Id)
)

CREATE TABLE Purchases(
    MovieId INT NOT NULL,
    UserId INT NOT NULL,
    PurchaseDateTime DATETIME2 NOT NULL,
    PurchaseNumber UNIQUEIDENTIFIER NOT NULL,
    TotalPrice DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (MovieId, UserId),
    FOREIGN KEY (MovieId) REFERENCES Movies(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
)

CREATE TABLE Roles(
    Id INT PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
)

CREATE TABLE UserRoles(
    RoleId INT NOT NULL,
    UserId INT NOT NULL,
    PRIMARY KEY (RoleId, UserId),
    FOREIGN KEY (RoleId) REFERENCES Roles(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
)