<?php
namespace Dev;
use Composer\IO\NullIO;
use Incenteev\ParameterHandler\Processor;

require_once __DIR__ . '/vendor/autoload.php';

$processor = new Processor(new NullIO());
$processor->processFile([
    'file' => 'config/parameters.yml',
    'env-map' => [
        'database_driver' => 'ORO_DATABASE_DRIVER',
        'database_host' => 'ORO_DATABASE_HOST',
        'database_port' => 'ORO_DATABASE_PORT',
        'database_name' => 'ORO_DATABASE_NAME',
        'database_user' => 'ORO_DATABASE_USER',
        'database_password' => 'ORO_DATABASE_PASSWORD',
        'database_driver_options' => 'ORO_DATABASE_DRIVER_OPTIONS',
        'mailer_transport' => 'ORO_MAILER_TRANSPORT',
        'mailer_host' => 'ORO_MAILER_HOST',
        'mailer_port' => 'ORO_MAILER_PORT',
        'mailer_encryption' => 'ORO_MAILER_ENCRYPTION',
        'mailer_user' => 'ORO_MAILER_USER',
        'mailer_password' => 'ORO_MAILER_PASSWORD',
        'websocket_frontend_host' => 'ORO_WEBSOCKET_FRONTEND_HOST',
        'websocket_frontend_port' => 'ORO_WEBSOCKET_FRONTEND_PORT',
        'websocket_frontend_path' => 'ORO_WEBSOCKET_FRONTEND_PATH',
        'web_backend_prefix' => 'ORO_WEB_BACKEND_PREFIX',
        'session_handler' => 'ORO_SESSION_HANDLER',
        'locale' => 'ORO_LOCALE',
        'secret' => 'ORO_SECRET',
        'message_queue_transport' => 'ORO_MESSAGE_QUEUE_TRANSPORT',
        'message_queue_transport_config' => 'ORO_MESSAGE_QUEUE_TRANSPORT_CONFIG',
        'enable_price_sharding' => 'ORO_ENABLE_PRICE_SHARDING'
    ]
]);
