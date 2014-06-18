<?php
/**
 * CsnUser - Coolcsn Zend Framework 2 User Module
 * 
 * @link https://github.com/coolcsn/CsnUser for the canonical source repository
 * @copyright Copyright (c) 2005-2013 LightSoft 2005 Ltd. Bulgaria
 * @license https://github.com/coolcsn/CsnUser/blob/master/LICENSE BSDLicense
 * @author Stoyan Cheresharov <stoyan@coolcsn.com>
 * @author Svetoslav Chonkov <svetoslav.chonkov@gmail.com>
 * @author Nikola Vasilev <niko7vasilev@gmail.com>
 * @author Stoyan Revov <st.revov@gmail.com>
 * @author Martin Briglia <martin@mgscreativa.com>
 */

return array(
	'mail' => array(
		'transport' => array(
			'options' => array(
				#'host' => 'localhost',
				'host' => 'smtp.sendgrid.net',
				'connection_class'  => 'plain',
				'port' => '25',
				'connection_config' => array(
					'username' => 'eightyco',
					'password' => 'sendgrid3ightyc0',
					'ssl' => 'tls'
				),
			),  
		),
	),
);
