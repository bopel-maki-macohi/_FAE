import sys.io.File;

class Build
{
	static final F_ANIM_VERSION:String = File.getContent('FANIM.txt');

	static var app:Dynamic;

	static function main()
	{
		app = haxe.Json.parse(File.getContent('Project.json'));

		function e(element = '', variables:Array<String>, values:Array<String>)
		{
			var variableList = [
				for (i => variable in variables) if (values[i] != null) '$variable="${values[i]}"'
			];
			return '<$element ${variableList.join(' ')} />';
		}

		var elements = [
			'',
			e('app', ['title', 'file', 'version'], [app.title, app.file, app.version,]),
			e('app', ['main', 'package', 'company'], ['f_anim.FAnim', app.pkg, app.company ?? 'Maverick']),
			e('app', ['preloader'], ['flixel.system.FlxPreloader']),
			'',
			e('set', ['name', 'value'], ['SWF_VERSION', '11.8']),
			'',
			e('window', ['width', 'height', 'fps', 'background', 'hardware', 'vsync'], ['640', '480', '60', '#000000', 'true', 'false']),
			e('window', ['if', 'resizable'], ['html5', 'true']),
			e('window', ['if', 'orientation', 'fullscreen', 'resizable'], ['desktop', 'landscape', 'false', 'true']),
			e('window', ['if', 'orientation', 'fullscreen', 'width', 'height'], ['mobile', 'landscape', 'true', '0', '0']),
			'',
			e('set', ['name', 'value'], ['BUILD_DIR', 'export/release']),
			e('set', ['name', 'value', 'if'], ['BUILD_DIR', 'export/debug', 'debug']),
			'',
			e('source', ['path'], ['source']),
			e('assets', ['path', 'embed', 'rename'], ['assets', 'true', '']),
			'',
			e('haxelib', ['name'], ['flixel']),
			e('haxelib', ['name'], ['flixel-addons']),
			'',
			e('haxedef', ['name', 'value'], ['FANIM', F_ANIM_VERSION]),
			e('haxedef', ['name'], ['FLX_NO_HEALTH']),
			e('haxedef', ['name', 'if'], ['FLX_NO_MOUSE', 'mobile']),
			e('haxedef', ['name', 'if'], ['FLX_NO_KEYBOARD', 'mobile']),
			e('haxedef', ['name', 'if'], ['FLX_NO_TOUCH', 'desktop']),
			e('haxedef', ['name', 'unless'], ['FLX_NO_DEBUG', 'debug']),
			e('haxedef', ['name', 'unless'], ['NAPE_RELEASE_BUILD', 'debug']),
			e('haxedef', ['name', 'value'], ['message.reporting', 'pretty']),
			'',
		];

		if (app.custom != null)
		{
			var custom:Dynamic = app.custom;

			for (field in Reflect.fields(custom))
			{
				// trace(field);

				var fieldContent:Array<Dynamic> = Reflect.field(custom, field);

				for (v in fieldContent)
				{
					// trace(v);
					elements.push(e(field, [for (field in Reflect.fields(v)) field], [for (field in Reflect.fields(v)) Reflect.field(v, field)]));
				}
			}
		}

		var project:String = '<project>\n';

		for (element in elements) project += '$element\n';

		project += '</project>';

		File.saveContent('Project.xml', project);
	}
}
