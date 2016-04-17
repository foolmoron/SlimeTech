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
import luxe.components.physics.nape.*;
import nape.phys.*;
import nape.shape.*;
import entities.*;
import states.*;

class Main extends luxe.Game {

    public static var rand = new Random(0x3389345);
    public static var state : States;
    public static var gridSize = 32;

    public static var grid = new Array<Array<Float>>();
    public static var gridCalcFrame = true;

    override function config(config:luxe.AppConfig) {
        config.preload.textures.push({ id:'assets/textures/blob.png' });
        config.preload.textures.push({ id:'assets/textures/blobback.png' });
        return config;
    }

    override function ready() {
        log('READY');
        new FPS();

        // physics
        Luxe.physics.nape.gravity = new Vec(0, 0);

        // border physics
        var border = new Body(BodyType.STATIC);
        border.shapes.add(new Polygon(Polygon.rect(0, 0, Luxe.screen.w, -1)));
        border.shapes.add(new Polygon(Polygon.rect(0, Luxe.screen.h, Luxe.screen.w, 1)));
        border.shapes.add(new Polygon(Polygon.rect(0, 0, -1, Luxe.screen.h)));
        border.shapes.add(new Polygon(Polygon.rect(Luxe.screen.w, 0, 1, Luxe.screen.h)));
        border.space = Luxe.physics.nape.space;

        // background
        var background = new Sprite({
            name: 'background',
            color: new Color().rgb(0xe9e9e9),
            pos: Luxe.screen.mid,
            size: Luxe.screen.size,
            depth: -100,
        });

        // grid lines
        var xgrid = Math.floor(Luxe.screen.size.x / gridSize);
        var ygrid = Math.floor(Luxe.screen.size.y / gridSize);
        for (x in 1 ... xgrid) {
            Luxe.draw.line({
                p0: new Vec(x * gridSize, 0),
                p1: new Vec(x * gridSize, Luxe.screen.size.y),
                color: new Color().rgb(0xb8b8b8),
            });
        }
        for (y in 1 ... ygrid) {
            Luxe.draw.line({
                p0: new Vec(0, y * gridSize),
                p1: new Vec(Luxe.screen.size.x, y * gridSize),
                color: new Color().rgb(0xb8b8b8),
            });
        }

        // grid setup
        for (x in 0 ... xgrid) {
            grid.push(new Array<Float>());
            for (y in 0 ... ygrid) {
                grid[x].push(0);
            }
        }

        // states
        state = new States({ name: 'game' });

        state.add(new TitleState({name: 'title'}));
        state.add(new GameState({name: 'game'}));
        Luxe.on(Ev.init, function(_) {
            state.set('game');
        });
    }

    override function onkeyup(e:KeyEvent) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
    }

    override function update(dt:Float) {
        if (gridCalcFrame) {
            for (x in 0 ... grid.length) {
                for (y in 0 ... grid[x].length) {
                    grid[x][y] = 0;
                }
            }            
        }
        gridCalcFrame = !gridCalcFrame;
    }

    public static function tex(id:String) {
        return Luxe.resources.texture('assets/textures/' + id + '.png');
    }
}