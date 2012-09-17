define gitfunc::func(
	$url,
	$branch='master',
	$path='/root',
	$env='install',
){
	package{"python-pip":
		ensure => installed,
	}
 	Package["python-pip"]->Exec["pip-requires"]
	Exec{
		path	=> ["/usr/bin", "/usr/sbin"],
	}

	exec{$name:
		command => "git clone $url -l $path/$name -b $branch",
		notify 	=> Exec["pip-requires"],
	}	
	
	exec{"pip-requires":
		command => "/usr/bin/pip install -r $path/$name/tools/pip-requires",
		require	=> Exec[$name],
		notify	=> Exec["install"],
		cwd	=> "$path/$name",
	}

	exec{"install":
		command	=> "python setup.py $env",
		require => Exec["pip-requires"],
		cwd	=> "$path/$name",
	}
}
