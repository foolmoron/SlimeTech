import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.States;
import luxe.Vector;
import luxe.Ev;
import luxe.Log.*;
import luxe.utils.Random;
import luxe.utils.Maths;
import luxe.tween.easing.*;
import entities.*;
import states.*;

class Main extends luxe.Game {

    public static var rand = new Random(0x3389345);
    public static var state:States;

    override function config(config:luxe.AppConfig) {
        config.preload.textures.push({ id:'assets/textures/blob.png' });
        config.preload.textures.push({ id:'assets/textures/blobback.png' });
        return config;
    }

    override function ready() {
        log('READY');
        new FPS();

        // background
        var background = new Sprite({
            name: 'background',
            color: new Color().rgb(0xe9e9e9),
            pos: Luxe.screen.mid,
            size: Luxe.screen.size,
        });

        // states
        state = new States({ name: 'game' });

        state.add(new TitleState({name: 'title'}));
        state.add(new GameState({name: 'game'}));
        Luxe.on(Ev.init, function(_) {
            state.set('title');
        });
    }

    override function onkeyup(e:KeyEvent) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
    }

    override function update(dt:Float) {
    }

    public static function tex(id:String) {
        return Luxe.resources.texture('assets/textures/' + id + '.png');
    }
}