/*
 * Pipeline to build the libyaml port on a Windows node.
 * This pipeline should work on any J06.22 or L19.02 system or above, providing
 * the MAKE-BUILD-OPTIONS.name exists to deal with hard-coding requirements
 * and has no hard-coding requirements for a particular agent. The job requires
 * access to the 'apache' class node for doxygen updates, 'glass' node for the
 * official build and 'nonstop' for the test node (when that is turned on).
 *
 * Extensions, at some point, we may get both J and L, which would require a
 * duplicate build/test step on the two nodes and differentiate 'nonstop' into
 * 'nonstop-J' and 'nonstop-L'.
 */
 pipeline {
	agent none
	options {
		buildDiscarder(logRotator(numToKeepStr: '2'))
	}
	stages {
		stage('development') {
			when {
				anyOf { branch 'development' }
			}
			steps {
				lock(resource: 'libyaml-test-environment') {
				    node('nonstop') {
				        checkout([$class: 'GitSCM',
				            branches: [[name: '*/development']],
				            extensions: [
				            	[$class: 'CleanBeforeCheckout'],
				            	[$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: true,
				            		recursiveSubmodules: true, reference: '', trackingSubmodules: false]],
				            	doGenerateSubmoduleConfigurations: false, submoduleCfg: [],
				            userRemoteConfigs: [[credentialsId: 'Randall', url: 'git@github.com:rsbeckerca/libyaml.git']]])
				        sh 'make -f Makefile.nse.GRD TARGET=/G/data01/randall/libyaml'
				        sh 'cp -p include/yaml.h ..'
			        }
		        }
		    }
		}
/*
		stage('test') {
			when {
				anyOf { branch 'development' }
			}
			steps {
				lock(resource: 'libyaml-test-environment') {
				    node('nonstop') {
				        sh 'make -f Makefile.nse.OSS test'
				    }
			    }
		    }
		}
*/
		stage('release') {
			when {
				branch 'production'
			}
			steps {
				lock(resource: 'libyaml-prod-build') {
					node('glass') {
				        checkout([$class: 'GitSCM',
				            branches: [[name: '*/production']],
				            extensions: [
				            	[$class: 'CleanBeforeCheckout'],
				            	[$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: true,
				            		recursiveSubmodules: true, reference: '', trackingSubmodules: false]],
				            	doGenerateSubmoduleConfigurations: false, submoduleCfg: [],
				            userRemoteConfigs: [[credentialsId: 'Randall', url: 'git@github.com:rsbeckerca/libyaml.git']]])
			        	withEnv(['COMP_ROOT=C:\\Program Files (x86)\\HPE NonStop\\J06.20',
			        		'NONSTOPOSVERSION=J06.20',
			        		'NSDEE_SYS_INCLUDE_PATH=C:\\Program Files (x86)\\HPE NonStop\\J06.20\\usr\\include',
			        		'NSDEE_SYS_INCLUDE_PATH_ESC=C:\\\\Program Files (x86)\\\\HPE NonStop\\\\J06\\.20\\\\usr\\\\include',
			        		'PATH+WHATEVER=C:\\Program Files (x86)\\HPE NonStop\\J06.20\\usr\\bin;C:\\cygwin\\bin;']) {
			        		
			        		echo 'About to start the J-series Guardian production build'
				            sh 'make -f Makefile.nse.GRD clean'
				            sh 'make -f Makefile.nse.GRD TARGET=../libyaml.J.dll'
					        sh 'cp -p include/yaml.h ..'
					    }
			        	withEnv(['COMP_ROOT=C:\\Program Files (x86)\\HPE NonStop\\J06.20',
			        		'NONSTOPOSVERSION=J06.20',
			        		'NSDEE_SYS_INCLUDE_PATH=C:\\Program Files (x86)\\HPE NonStop\\J06.20\\usr\\include',
			        		'NSDEE_SYS_INCLUDE_PATH_ESC=C:\\\\Program Files (x86)\\\\HPE NonStop\\\\J06\\.20\\\\usr\\\\include',
			        		'PATH+WHATEVER=C:\\Program Files (x86)\\HPE NonStop\\J06.20\\usr\\bin;C:\\cygwin\\bin;']) {
			        		
			        		echo 'About to start the J-series OSS build'
				            sh 'make -f Makefile.nse.Nsdee clean'
				            sh 'make -f Makefile.nse.Nsdee TARGET=../libyaml.J.so'
					        sh 'cp -p include/yaml.h ..'
					    }
			        	withEnv(['COMP_ROOT=C:\\Program Files (x86)\\HPE NonStop\\L16.05',
			        		'NONSTOPOSVERSION=L16.05',
			        		'NSDEE_SYS_INCLUDE_PATH=C:\\Program Files (x86)\\HPE NonStop\\L16.05\\usr\\include',
			        		'NSDEE_SYS_INCLUDE_PATH_ESC=C:\\\\Program Files (x86)\\\\HPE NonStop\\\\L16\\.05\\\\usr\\\\include',
			        		'PATH+WHATEVER=C:\\Program Files (x86)\\HPE NonStop\\L16.05\\usr\\bin;C:\\cygwin\\bin;']) {
			        		
				            sh 'make -f Makefile.nsx.GRD clean'
				            sh "make -f Makefile.nsx.GRD NONSTOPOSVERSION=${NONSTOPOSVERSION} TARGET=../libyaml.L.dll"
					        sh 'cp -p include/yaml.h ..'
					    }
			        	withEnv(['COMP_ROOT=C:\\Program Files (x86)\\HPE NonStop\\L16.05',
			        		'NONSTOPOSVERSION=L16.05',
			        		'NSDEE_SYS_INCLUDE_PATH=C:\\Program Files (x86)\\HPE NonStop\\L16.05\\usr\\include',
			        		'NSDEE_SYS_INCLUDE_PATH_ESC=C:\\\\Program Files (x86)\\\\HPE NonStop\\\\L16\\.05\\\\usr\\\\include',
			        		'PATH+WHATEVER=C:\\Program Files (x86)\\HPE NonStop\\L16.05\\usr\\bin;C:\\cygwin\\bin;']) {
			        		
				            sh 'make -f Makefile.nsx.Nsdee clean'
				            sh "make -f Makefile.nsx.Nsdee NONSTOPOSVERSION=${NONSTOPOSVERSION} TARGET=../libyaml.L.so"
					        sh 'cp -p include/yaml.h ..'
					    }
					}
				}
			}
		}
	}
	post {
        always {
            mail bcc: '', body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\nDuration: ${currentBuild.durationString}\nMore info at: ${env.BUILD_URL}", cc: '', from: 'rsbecker@nexbridge.com', replyTo: '', subject: "[Jenkins nonstop] ${currentBuild.currentResult}: job ${env.JOB_NAME}", to: 'rsbecker@nexbridge.com'
        }
	}
}