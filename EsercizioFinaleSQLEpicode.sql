-- creazione DATABASE
CREATE DATABASE ToysGroup

-- creazioni tabelle
CREATE TABLE Prodotti (
    ProdottoID INT PRIMARY KEY,
    Nome_Prodotto VARCHAR(55),
    Categoria VARCHAR(55)
);

CREATE TABLE Regioni (
    RegioneID INT PRIMARY KEY,
    Nome_Regione VARCHAR(55),
    Stato VARCHAR(55)
);

CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    ProdottoID INT,
    RegioneID INT,
    DataVendita DATE,
    Ammontare DECIMAL(10, 2),
    FOREIGN KEY (ProdottoID) REFERENCES Prodotti(ProdottoID),
    FOREIGN KEY (RegioneID) REFERENCES Regioni(RegioneID)
);

-- Inserimento dati nella tabella Product
INSERT INTO Prodotti (ProdottoID, Nome_Prodotto, Categoria)
VALUES
    (1, 'Action Figure', 'Toys'),
    (2, 'Board Game', 'Games'),
    (3, 'Doll', 'Toys'),
    (4, 'Remote Control Car', 'Toys'),
    (5, 'Puzzle', 'Games'),
    (6, 'LEGO Set', 'Toys'),
    (7, 'Stuffed Animal', 'Toys'),
    (8, 'Model Train', 'Hobby'),
    (9, 'Educational Toy', 'Toys'),
    (10, 'Outdoor Toy', 'Toys'),
    (11, 'Toy Kitchen Set', 'Toys'),
    (12, 'Construction Set', 'Toys'),
    (13, 'Musical Instrument Toy', 'Toys'),
    (14, 'Toy Robot', 'Toys'),
    (15, 'Art and Craft Kit', 'Toys');

-- Inserimento dati nella tabella Region
INSERT INTO Regioni (RegioneID, Nome_Regione, Stato)
VALUES
    (1, 'North America', 'USA'),
    (2, 'Europe', 'Germany'),
    (3, 'Asia', 'China'),
    (4, 'South America', 'Brazil'),
    (5, 'Africa', 'South Africa'),
    (6, 'Oceania', 'Australia'),
    (7, 'Middle East', 'Saudi Arabia'),
    (8, 'Central America', 'Mexico'),
    (9, 'Caribbean', 'Jamaica'),
    (10, 'Scandinavia', 'Sweden'),
    (11, 'Eastern Europe', 'Poland'),
    (12, 'Southeast Asia', 'Indonesia'),
    (13, 'South Asia', 'India'),
    (14, 'Central Asia', 'Kazakhstan'),
    (15, 'Northern Europe', 'Norway');

-- Inserimento dati nella tabella Sales
INSERT INTO Sales (SalesID, ProdottoID, RegioneID, DataVendita, Ammontare)
VALUES
    (1, 1, 1, '2023-01-15', 50.00),
    (2, 2, 1, '2023-02-20', 30.00),
    (3, 1, 2, '2023-03-10', 40.00),
    (4, 3, 2, '2023-04-05', 25.00),
    (5, 4, 3, '2023-05-12', 35.00),
    (6, 5, 3, '2023-06-18', 20.00),
    (7, 6, 4, '2023-07-25', 45.00),
    (8, 7, 4, '2023-08-30', 15.00),
    (9, 8, 5, '2023-09-05', 55.00),
    (10, 9, 5, '2023-10-10', 60.00),
    (11, 10, 6, '2023-11-15', 25.00),
    (12, 11, 6, '2023-12-20', 35.00),
    (13, 12, 7, '2024-01-01', 40.00),
    (14, 13, 7, '2024-02-05', 20.00),
    (15, 14, 8, '2024-03-10', 30.00);
	
/* Ora svolgo le query
*/	
	
-- Query per verificare unicità delle chiavi primarie
SELECT COUNT(*) AS NumDuplicates
FROM (
    SELECT ProductID, COUNT(*) AS NumOccurrences
    FROM Product
    GROUP BY ProductID
    HAVING COUNT(*) > 1
) AS Subquery;

-- Elenco dei soli prodotti venduti e il fatturato totale per anno
SELECT p.Name AS ProductName, YEAR(s.SaleDate) AS Year, SUM(s.Amount) AS TotalRevenue
FROM Product p
INNER JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.Name, YEAR(s.SaleDate);

-- Fatturato totale per stato per anno, ordinato per data e fatturato decrescente
SELECT r.State, YEAR(s.SaleDate) AS Year, SUM(s.Amount) AS TotalRevenue
FROM Region r
INNER JOIN Sales s ON r.RegionID = s.RegionID
GROUP BY r.State, YEAR(s.SaleDate)
ORDER BY YEAR(s.SaleDate), TotalRevenue DESC;

-- La categoria di articoli maggiormente richiesta dal mercato
SELECT p.Category, COUNT(*) AS TotalSales
FROM Product p
INNER JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.Category
ORDER BY TotalSales DESC
LIMIT 1;

-- Prodotti invenduti, approccio 1
SELECT p.*
FROM Product p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SalesID IS NULL;

-- Prodotti invenduti, approccio 2;
SELECT *
FROM Product
WHERE ProductID NOT IN (SELECT ProductID FROM Sales);

-- Elenco dei prodotti con la rispettiva ultima data di vendita
SELECT p.Name AS ProductName, MAX(s.SaleDate) AS LastSaleDate
FROM Product p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.Name;
