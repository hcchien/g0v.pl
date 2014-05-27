require! 'github'
require! 'fs'
(err) <- fs.unlink './foo.json'
if err
	console.log err
setting = ''
(err,data) <- fs.readFile 'setting.json'
if data
	setting := JSON.parse(new Buffer(data, "base64").toString()).deploy;
hub = new github({version: '3.0.0', proxy: 'http://utcr.org:8080', protocol: 'http', host: 'utcr.org', port: 8080});
(err, res) <- hub.repos.getFromOrg {org: 'g0v'}
unless err
	for r in res
		(err, res) <- hub.repos.getContent {user: 'g0v', repo: r.name, path: 'g0v.json'}
		if res
			project = new Buffer(res.content, "base64").toString()
			try 
				sp = {}
				p = JSON.parse(project)
				np = {}
				for f in setting.public.fields
					if p.{f}
						np.[f] = p.[f]
				sp.[p.name] = np;
				(err) <- fs.writeFile('./foo.json', JSON.stringify(sp), {'flag': 'a'}) 
				if (err)
					throw err
					console.log err
			catch ex
				console.log ex
else
	console.log err
