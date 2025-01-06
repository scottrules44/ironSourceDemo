local ironSource = require "plugin.ironSource"

--


local json= require "json"
local widget = require("widget")

local someLoopingMusic = audio.loadStream( "sampleMusic.mp3" )
local someLoopingMusicChannel = audio.play( someLoopingMusic, { channel=1, loops=-1 } )

local scale0X= ((display.actualContentWidth- display.contentWidth)*.5)*-1
local scale0Y= ((display.actualContentHeight- display.contentHeight)*.5)*-1
display.setStatusBar( display.HiddenStatusBar )
--use this for testing
print("Ad Id (used for testing)")
print("------------------- ")
print(ironSource.getAdId())
print("-------------------")
ironSource.setFBTrackingEnabled(true)
ironSource.debugMode()
--Predeclare
local showRewardVideo
local loadRewardVideo
local showInterstitial
local loadInterstitial
local testScene
--

local widget = require("widget")

local composer = require( "composer" )

local scene = composer.newScene()


function scene:create( event )
    local bannerHeight = 0
    local topBanner
    local function adLis(event)
        print("Iron Source event")
        print("-------------------")
        print(json.encode(event))
        print("-------------------")

        if (event.type == "banner") then
            if (event.phase == "adReady") then
                 bannerHeight = ironSource.getSize()
                 topBanner.height = bannerHeight
                 topBanner.y= 0-scale0Y+(bannerHeight/2)
                 ironSource.show("banner", {position = "top"})
            elseif (event.phase == "adLoadedFailed" and event.error ~= "No ads to show") then
                print("No Ads :((())")
            end
        end

        if (event.type == "rewardedVideo") then
            if (event.phase == "adReady") then
                showRewardVideo:setEnabled( true )
                showRewardVideo.alpha = 1
                showRewardVideo:setLabel( "Show Reward Video" )
            end
        end

        if (event.type == "rewardedVideo") then
            if (event.phase == "adRewarded") then
                print("Rewarded For video, Got:"..event.rewardAmount)
            end
        end
        if (event.type == "interstitial") then
            if (event.phase == "adReady") then
                showInterstitial:setEnabled( true )
                showInterstitial.alpha = 1
            end
        end
    end
    --Init within 10 seconds to test banners

    timer.performWithDelay( 10000, function ()
        ironSource.load("banner", { iOSAdUnitId = "iep3rxsyp9na3rw8", androidAdUnitId = "thnfvcsog13bhn08"})
    end, 0)


    local sceneGroup = self.view
    local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
    bg:setFillColor( 0,0,1 )
    sceneGroup:insert( bg )
    topBanner = display.newRect( display.contentCenterX, 0-scale0Y+(bannerHeight/2),display.actualContentWidth, bannerHeight)
    topBanner.alpha = .5
    local title = display.newText( {text = "Iron Source Plugin", fontSize = 20} )
    title.width, title.height = 300, 168
    title.x, title.y = display.contentCenterX, 140*.5
    title:setFillColor(1,1,1)
    sceneGroup:insert( title )


    showRewardVideo= widget.newButton({
        label = "Loading Reward",
        x = display.contentCenterX,
        y = display.contentCenterY-130,
        id = "showReward",
        isEnabled = false,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onRelease =  function ()
            if (ironSource.isLoaded("rewardedVideo") == true) then
                ironSource.show("rewardedVideo")
            else
                native.showAlert( "Video not loaded", "Could not load reward video", {"Ok"} )
            end
        end

    })
    sceneGroup:insert( showRewardVideo )
    showRewardVideo.alpha = .5
    showRewardVideo:setEnabled( false )

    loadRewardVideo= widget.newButton({
        label = "Load Reward Video",
        x = display.contentCenterX,
        y = display.contentCenterY-90,
        id = "showReward",
        isEnabled = true,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onRelease =  function ()
            ironSource.load("rewardedVideo", {iOSAdUnitId = "qwouvdrkuwivay5q", androidAdUnitId = "6qzplev7gav9w2of"})
        end

    })
    sceneGroup:insert( loadRewardVideo )

    showInterstitial= widget.newButton({
        label = "Show Interstitial",
        x = display.contentCenterX,
        y = display.contentCenterY,
        id = "showInterstitial",
        isEnabled = false,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onRelease =  function ()
            if (ironSource.isLoaded("interstitial") == true) then
                ironSource.show("interstitial")
                showInterstitial.alpha = .5
                showInterstitial:setEnabled( false )
            else
                native.showAlert( "Interstitial not loaded", "Could not load interstitial", {"Ok"} )
            end
        end

    })
    sceneGroup:insert( showInterstitial )
    showInterstitial.alpha = .5
    showInterstitial:setEnabled( false )

    loadInterstitial= widget.newButton({
        label = "Load Interstitial",
        x = display.contentCenterX,
        y = display.contentCenterY-50,
        id = "loadInterstitial",
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onRelease =  function ()
            ironSource.load("interstitial", { iOSAdUnitId = "wmgt0712uuux8ju4", androidAdUnitId = "aeyqi3vqlv6o8sh9" })
        end
    })
    sceneGroup:insert( loadInterstitial )

    testScene= widget.newButton({
        label = "Show Test Scene",
        x = display.contentCenterX,
        y = display.contentCenterY+50,
        id = "showScene",
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onRelease =  function ()
            composer.showOverlay( "testScene" )
        end

    })
    sceneGroup:insert( testScene )
    init1= widget.newButton({
        label = "Init with No ATT",
        x = display.contentCenterX,
        y = display.contentCenterY+100,
        id = "init1",
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onRelease =  function ()
            ironSource.init(adLis, { androidAppKey="85460dcd", iOSAppKey= "8545d445"})
        end
    })
    sceneGroup:insert( init1 )

    init2 = widget.newButton({
        label = "Init with ATT",
        x = display.contentCenterX,
        y = display.contentCenterY+150,
        id = "init2",
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onRelease =  function ()
            --ironSource.setMetaData("tapjoy_coppa", "true")
            --ironSource.setMetaData("Tapjoy_optOutAdvertisingID", "false")

            ironSource.init(adLis, {androidAppKey="85460dcd", iOSAppKey= "8545d445", enableATT=true, testSuite= true})
        end

    })
    sceneGroup:insert( init2 )
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
end


-- hide()
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
