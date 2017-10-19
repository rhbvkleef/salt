<?php
namespace Project;

$cfg = [];

// database configuration
$cfg['database_host'] = "{{ salt[pillar.get]('skicie-signup:db:host') }}";
$cfg['database_pass'] = "{{ salt[pillar.get]('skicie-signup:db:pass') }}";
$cfg['database_user'] = "{{ salt[pillar.get]('skicie-signup:db:user') }}";
$cfg['database_db']   = "{{ salt[pillar.get]('skicie-signup:db:name') }}";

// specify possibility of enrolling and timeframe, if null will be ignored
$cfg['can_enroll'] = false;
$cfg['start_enrollment'] = \DateTime::createFromFormat('Y-m-d H:i', '2017-12-14 16:00');
$cfg['end_enrollment'] = null;

// password to use when going to the admin panel => /admin/?pass={password}
$cfg['admin_pass'] = '{{ pillar['skicie-signup']['admin']['pass'] }}';

// base url for the website, if in root: ''
$cfg['basePath'] = '';