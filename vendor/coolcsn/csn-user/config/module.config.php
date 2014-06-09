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
    'controllers' => array(
        'invokables' => array(
            'CsnUser\Controller\Index' => 'CsnUser\Controller\IndexController',
            'CsnUser\Controller\Registration' => 'CsnUser\Controller\RegistrationController',
            'CsnUser\Controller\Resetpassword' => 'CsnUser\Controller\ResetpasswordController',
        ),
    ),
    'router' => array(
        'routes' => array(
            'user-index' => array(
                'type' => 'Segment',
                'options' => array(
                    'route' => '/user[/:action]',
                    'constraints' => array(
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                    ),
                    'defaults' => array(
                        'controller' => 'CsnUser\Controller\Index',
                        #'action' => 'login',
                    ),
                ),
                'may_terminate' => true,
            ),
            'user-register' => array(
                'type' => 'Segment',
                'options' => array(
                    'route' => '/user/register[/:action][/:id]',
                    'constraints' => array(
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'id' => '[a-zA-Z0-9]*',
                    ),
                    'defaults' => array(
                        'controller' => 'CsnUser\Controller\Registration',
                        #'action' => 'index',
                    ),
                ),
                'may_terminate' => true,
            ),

          'passwordreset' => array(
                'type' => 'Segment',
                'options' => array(
                    'route' => '/user/passwordreset[/:action][/:id]',
                    'constraints' => array(
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'id' => '[a-zA-Z0-9]*',
                    ),
                    'defaults' => array(
                        'controller' => 'CsnUser\Controller\Resetpassword',
                        #'action' => 'index',
                    ),
                ),
                'may_terminate' => true,
            ),
        ),
    ),
    'view_manager' => array(
         'strategies' => array(
            'ViewJsonStrategy',
         ),

        'display_exceptions' => true,
        'template_path_stack' => array(
            'csn-user' => __DIR__ . '/../view'
        ),

       
    ),
    'service_manager' => array (
        'factories' => array(
            'Zend\Authentication\AuthenticationService' => 'CsnUser\Service\Factory\AuthenticationFactory',
            'mail.transport' => 'CsnUser\Service\Factory\MailTransportFactory',
            'csnuser_module_options' => 'CsnUser\Service\Factory\ModuleOptionsFactory',
            'csnuser_error_view' => 'CsnUser\Service\Factory\ErrorViewFactory',
            'csnuser_user_form' => 'CsnUser\Service\Factory\UserFormFactory',
        ),
    ),
    'doctrine' => array(
        'configuration' => array(
            'orm_default' => array(
                'generate_proxies' => true,
            ),
        ),
        'authentication' => array(
            'orm_default' => array(
                'object_manager' => 'Doctrine\ORM\EntityManager',
                'identity_class' => 'CsnUser\Entity\Customer',
                'identity_property' => 'email',
                'credential_property' => 'password',
                'credential_callable' => 'CsnUser\Service\UserService::verifyHashedPassword',
            ),
        ),
        'driver' => array(
            'csnuser_driver' => array(
                'class' => 'Doctrine\ORM\Mapping\Driver\AnnotationDriver',
                'cache' => 'array',
                'paths' => array(
                    __DIR__ . '/../src/CsnUser/Entity',
                ),
            ),
            'orm_default' => array(
                'drivers' => array(
                    'CsnUser\Entity' => 'csnuser_driver',
                ),
            ),
        ),
    ),
);
