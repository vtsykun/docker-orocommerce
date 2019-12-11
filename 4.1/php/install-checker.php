<?php

// This script tried to connect to the database
// and check if the application is installed

require_once __DIR__ . '/vendor/autoload.php';

$params = (new \Symfony\Component\Yaml\Parser())
    ->parse(file_get_contents(__DIR__ . '/config/parameters.yml'));
$params = $params['parameters'];

$config = new \Doctrine\DBAL\Configuration();
$connectionParams = [
    'dbname' => $params['database_name'],
    'user' => $params['database_user'],
    'password' => $params['database_password'],
    'host' => $params['database_host'],
    'driver' => $params['database_driver'],
];
$conn = \Doctrine\DBAL\DriverManager::getConnection($connectionParams, $config);
$sm = $conn->getSchemaManager();

if ($sm->tablesExist(['oro_user', 'oro_migrations', 'oro_config'])) {
    echo "true";
} else {
    echo "false";
}
