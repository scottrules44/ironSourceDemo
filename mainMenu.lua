local ironSource = require "plugin.ironSource"
local json= require "json"
local widget = require("widget")
local scale0X= ((display.actualContentWidth- display.contentWidth)*.5)*-1
local scale0Y= ((display.actualContentHeight- display.contentHeight)*.5)*-1
display.setStatusBar( display.HiddenStatusBar )
--use this for testing
print("Ad Id (used for testing)")
print("------------------- ")
print(ironSource.getAdId())
print("-------------------")

ironSource.debugMode()
--Predeclare
local showRewardVideo
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
            if (event.phase == "adLoaded") then
                 bannerHeight = ironSource.getSize()
                 print(bannerHeight)
                 topBanner.height = bannerHeight
                 topBanner.y= 0-scale0Y+(bannerHeight/2)
            elseif (event.phase == "adLoadedFailed" and event.error ~= "No ads to show") then

            end
        end

        if (event.type == "rewardedVideo") then
            if (event.phase == "availabilityChanged") then
                if (event.available == true) then
                    showRewardVideo:setEnabled( true )
                    showRewardVideo.alpha = 1
                    showRewardVideo:setLabel( "Show Reward Video" )
                end
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
    ironSource.init(adLis,{androidAppKey="replace this", iOSAppKey= "replace this"})

    timer.performWithDelay( 5000, function ()
        ironSource.show("banner", {position = "top"})
        ironSource.load("banner")
    end, -1)


    local sceneGroup = self.view
    local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
    bg:setFillColor( 0,0,1 )
    sceneGroup:insert( bg )
    topBanner = display.newRect( display.contentCenterX, 0-scale0Y+(bannerHeight/2),display.actualContentWidth, bannerHeight)
    topBanner.alpha = .5
    local title = display.newText( {text = "Iron Source Plugin", fontSize = 30} )
    title.width, title.height = 300, 168
    title.x, title.y = display.contentCenterX, 168*.5
    title:setFillColor(1,1,1)
    sceneGroup:insert( title )

    showRewardVideo= widget.newButton({
        label = "Loading Reward",
        x = display.contentCenterX,
        y = display.contentCenterY-100,
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
            ironSource.load("interstitial")
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
