-- Initial data for testing
INSERT INTO data_table (name, description, value) VALUES 
('Item 1', 'First test item', 'Value 1'),
('Item 2', 'Second test item', 'Value 2'),
('Item 3', 'Third test item', 'Value 3')
ON CONFLICT DO NOTHING;

