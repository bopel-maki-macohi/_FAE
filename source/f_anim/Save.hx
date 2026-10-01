package f_anim;

import flixel.math.FlxRandom;
import flixel.util.FlxSave;

class Save extends FlxSave
{
	public static var instance:Save;

	override public function new(game:String, company:String)
	{
		super();

		bind(game, company);

		gameData ??= {};

		language ??= 'eng-US';
	}

	public var gameData(get, set):Dynamic;

	function get_gameData():Dynamic return data.gameData;

	function set_gameData(gameData:Dynamic):Dynamic return data.gameData = gameData;

	public var language(get, set):String;

	function get_language():String return gameData.language;

	function set_language(language:String):String return gameData.language = language;
}
