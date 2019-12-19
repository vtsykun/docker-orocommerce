<?php

use Symfony\Component\HttpFoundation\Request;

$loader = require __DIR__.'/../app/autoload.php';
require_once __DIR__.'/../app/AppKernel.php';

if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS']='on';
}

$kernel = new AppKernel('prod', false);

// For example 172.16.0.0/12 10.16.0.0/16
$trustedProxies = getenv('TRUSTED_PROXIES');

//$kernel = new AppCache($kernel);
$request = Request::createFromGlobals();
if ($trustedProxies) {
    $trustedProxies = explode(' ', $trustedProxies);
    Request::setTrustedProxies($trustedProxies);
}

$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);
