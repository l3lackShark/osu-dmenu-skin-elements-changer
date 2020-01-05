#!/bin/bash

#Put your osu! folder here!
export BASE_DIR="/home/blackshark/drives/ps3drive/osu!"

#Do not touch this unless it doesn't work! (specify your notification manager executable)
export NOTIFICATION_SYSTEM="notify-send"

#Get Current Skin Name
PLAIN_TEXT=$(cat "$BASE_DIR"/osu\!."$USER".cfg | sed -n 115p | sed 's/^.......//')
#############################
#Converting Skin Name to Path#
##############################
#Get Full Path to Current Skin
FULL_PATH=$(echo "$BASE_DIR"/Skins/"$PLAIN_TEXT" | tr -d '\r')

#Get Current skin.ini
export SKIN_INI_PATH="$FULL_PATH/skin.ini"






#Initial Question
initial=$(echo -e "Defaults\nFollowPoints\nCursor\nRestore"  | dmenu -i -p "Your current skin is $PLAIN_TEXT, choose the element that you want to modify.")

if [ "$initial" = "" ]
then
    exit 1
fi

if [ "$initial" = "FollowPoints" ]
then
    echo "User Have Chosen" "$initial"
    chosen=$(echo -e "Yes\nNo" | dmenu -i -p "Also include AnimationFramerate? (might break some animations but guarantees correct followpoint framerate.)")
    if [ "$chosen" = "" ]
    then
        exit 1
    fi


    if [ "$chosen" = "No"  ]
    then
        #Check if current skin has followpoints.
        followcheck=$(ls "$FULL_PATH" | grep followpoint)
        if [ "$followcheck" = "" ] #If it doesn't, then...
        then
            echo "I haven't exited yet!"
            skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take FollowPoints from.")
            $NOTIFICATION_SYSTEM "No followpoints in current directory, just copying new ones over"
            TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
            cd "$TEMP_SKIN_DIR" || { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
            echo "$TEMP_SKIN_DIR"
            assetpath=$(find "$TEMP_SKIN_DIR" -name followpoint.png | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//')
            if [ "$assetpath" = "" ]
            then
                followcheck=$(ls "$TEMP_SKIN_DIR" | grep followpoint)
                if [ "$followcheck"  = "" ]
                then { $NOTIFICATION_SYSTEM "No followpoints found in that skin!"; exit 1; }
                fi
            fi
            cd "$TEMP_SKIN_DIR" || exit

            mkdir "$FULL_PATH"/Restore
            mkdir "$FULL_PATH"/Restore/FollowPoints


            rm -f "$FULL_PATH"/Restore/FollowPoints/* && cp skin.ini "$FULL_PATH"/Restore/FollowPoints
            #echo $TEMP_SKIN_DIR
            cd "$TEMP_SKIN_DIR" || exit
            if [[ $(ls | grep followpoint) ]];
            then
                $NOTIFICATION_SYSTEM "OK!, copying files over..."
                cp -f followpoint*.png "$FULL_PATH"
            else
                $NOTIFICATION_SYSTEM "No FollowPoint files in root, searching..."
                cd "$TEMP_SKIN_DIR" || exit
                assetpath=$(find . -name followpoint.png | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//')
                echo "$assetpath" "HELLO"
                cd "$assetpath" || exit
                $NOTIFICATION_SYSTEM "OK! Found Assets in:""$assetpath" || { $NOTIFICATION_SYSTEM "No followpoints found in that skin!"; exit 1; }
                cp followpoint*.png "$FULL_PATH"

            fi

        else


            skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take FollowPoints from.")
            TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
            cd "$TEMP_SKIN_DIR" || { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }

            mkdir "$FULL_PATH"/Restore
            mkdir "$FULL_PATH"/Restore/FollowPoints


            rm -f "$FULL_PATH"/Restore/FollowPoints/*
            cd "$FULL_PATH" || exit
            cp -f followpoint*.png "$FULL_PATH"/Restore/FollowPoints && cp skin.ini "$FULL_PATH"/Restore/FollowPoints
            TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
            #echo $TEMP_SKIN_DIR
            cd "$TEMP_SKIN_DIR" || exit
            if [[ $(ls | grep followpoint) ]];
            then
                $NOTIFICATION_SYSTEM "OK!, copying files over..."
                cd "$FULL_PATH" || exit
                rm -f followpoint*.png
                cd "$TEMP_SKIN_DIR" || exit
                cp -f followpoint*.png "$FULL_PATH"
            else
                $NOTIFICATION_SYSTEM "No FollowPoint files in root, searching..."
                cd "$TEMP_SKIN_DIR" || exit
                assetpath=$(find . -name followpoint.png | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//')
                #echo $assetpath
                cd "$assetpath" || exit
                cp followpoint*.png "$FULL_PATH"
                $NOTIFICATION_SYSTEM "OK! Found Assets in:""$assetpath"
            fi
        fi
    fi
    if [ "$chosen" = "Yes" ]
    then
        #Check if current skin has followpoints.
        followcheck=$(ls "$FULL_PATH" | grep followpoint)
        if [ "$followcheck" = "" ] #If it doesn't, then...
        then
            echo "I haven't exited yet!"
            skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take FollowPoints from.")
            $NOTIFICATION_SYSTEM "No followpoints in current directory, just copying new ones over"
            TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
            cd "$TEMP_SKIN_DIR" || { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
            echo "$TEMP_SKIN_DIR"
            assetpath=$(find "$TEMP_SKIN_DIR" -name followpoint.png | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//')
            if [ "$assetpath" = "" ]
            then
                followcheck=$(ls "$TEMP_SKIN_DIR" | grep followpoint)
                if [ "$followcheck"  = "" ]
                then { $NOTIFICATION_SYSTEM "No followpoints found in that skin!"; exit 1; }
                fi
            fi
            cd "$TEMP_SKIN_DIR" || exit

            mkdir "$FULL_PATH"/Restore
            mkdir "$FULL_PATH"/Restore/FollowPoints


            rm -f "$FULL_PATH"/Restore/FollowPoints/* && cp skin.ini "$FULL_PATH"/Restore/FollowPoints
            #echo $TEMP_SKIN_DIR
            cd "$TEMP_SKIN_DIR" || exit
            if [[ $(ls | grep followpoint) ]];
            then
                $NOTIFICATION_SYSTEM "OK!, copying files over..."
                cp -f followpoint*.png "$FULL_PATH"
            else
                $NOTIFICATION_SYSTEM "No FollowPoint files in root, searching..."
                cd "$TEMP_SKIN_DIR" || exit
                assetpath=$(find . -name followpoint.png | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//')
                echo "$assetpath" "HELLO"
                cd "$assetpath" || exit
                $NOTIFICATION_SYSTEM "OK! Found Assets in:""$assetpath" || { $NOTIFICATION_SYSTEM "No followpoints found in that skin!"; exit 1; }
                cp followpoint*.png "$FULL_PATH"

            fi

        else


            skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take FollowPoints from.")
            TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
            cd "$TEMP_SKIN_DIR" || { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }

            mkdir "$FULL_PATH"/Restore
            mkdir "$FULL_PATH"/Restore/FollowPoints


            rm -f "$FULL_PATH"/Restore/FollowPoints/*
            cd "$FULL_PATH" || exit
            cp -f followpoint*.png "$FULL_PATH"/Restore/FollowPoints && cp skin.ini "$FULL_PATH"/Restore/FollowPoints
            TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
            #echo $TEMP_SKIN_DIR
            cd "$TEMP_SKIN_DIR" || exit
            if [[ $(ls | grep followpoint) ]];
            then
                $NOTIFICATION_SYSTEM "OK!, copying files over..."
                cd "$FULL_PATH" || exit
                rm -f followpoint*.png
                cd "$TEMP_SKIN_DIR" || exit
                cp -f followpoint*.png "$FULL_PATH"
            else
                $NOTIFICATION_SYSTEM "No FollowPoint files in root, searching..."
                cd "$TEMP_SKIN_DIR" || exit
                assetpath=$(find . -name followpoint.png | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//')
                #echo $assetpath
                cd "$assetpath" || exit
                cp followpoint*.png "$FULL_PATH"
                $NOTIFICATION_SYSTEM "OK! Found Assets in:""$assetpath"
            fi
        fi
        if cat "$TEMP_SKIN_DIR"/skin.ini | grep -q AnimationFramerate; #TODO "//" Handling
        then
            tmp_follow_line=$(grep -nr AnimationFramerate "$TEMP_SKIN_DIR"/skin.ini | cut -f1 -d:)
            follow_line=$(grep -nr AnimationFramerate "$SKIN_INI_PATH" | cut -f1 -d:)
            tmp_follow_fulltext=$(sed ''"$tmp_follow_line"'!d' "$TEMP_SKIN_DIR"/skin.ini | sed -e 's/^[ \t]*//')
            follow_fulltext=$(sed ''"$follow_line"'!d' "$SKIN_INI_PATH")
            echo "$tmp_follow_fulltext"
            sed -i "s/^.AnimationFramerate.*$/$tmp_follow_fulltext/" "$SKIN_INI_PATH" |
            $NOTIFICATION_SYSTEM "From:$follow_fulltext To:$tmp_follow_fulltext"
        else
            $NOTIFICATION_SYSTEM "AnimationFramerate not found, commenting previous value..."
            #tmp_null_framerate=$("//AnimationFramerate: 30")
            #sed 's/.*AnimationFramerate/'#&/' $SKIN_INI_PATH
            sed -i 's/^AnimationFramerate/#&/' "$SKIN_INI_PATH"


        fi
    fi
fi

if [ "$initial" = "Restore" ]
then
    echo "User Have Chosen" "$initial"
    chosen=$(echo -e "Defaults\nCursor\nFollowPoints" | dmenu -i -p "What do you want to restore?")

    if [ "$chosen" = "" ]
    then
        exit 1
    fi
    if [ "$chosen" = "FollowPoints" ]
    then
        cd "$FULL_PATH" || exit
        rm -f followpoint*.png
        rm -f skin.ini
        cd "$FULL_PATH"/Restore/FollowPoints || exit
        cp -- * "$FULL_PATH"/
        $NOTIFICATION_SYSTEM "Restored the FollowPoints!"
    fi
    if [ "$chosen" = "Defaults" ]
    then
        cd "$FULL_PATH" || exit
        rm -f default-*.png
        rm -f skin.ini
        cd "$FULL_PATH"/Restore/Defaults || exit
        cp -- * "$FULL_PATH"/
        $NOTIFICATION_SYSTEM "Restored the Defaults!"
    fi
    if [ "$chosen" = "Cursor" ]
    then
        cd "$FULL_PATH" || exit
        rm -f cursor*.png
        cd "$FULL_PATH"/Restore/Cursors || exit
        cp -- * "$FULL_PATH"/
        $NOTIFICATION_SYSTEM "Restored the Cursor!"
    fi


fi

if [ "$initial" = "Cursor" ]
then
    echo "User Have Chosen $initial, proceeding..."
    skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take cursor from.")
    if [ "$skin" = "" ]
    then
        exit 1
    fi
    mkdir "$FULL_PATH"/Restore
    mkdir "$FULL_PATH"/Restore/Cursors
    cd "$FULL_PATH"/Restore/Cursors || exit
    rm -f cursor*.png
    cd "$FULL_PATH" && cp -f cursor*.png "$FULL_PATH"/Restore/Cursors
    rm -f cursor*.png
    TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
    cd "$TEMP_SKIN_DIR" || exit
    cp cursor*.png "$FULL_PATH/"
    $NOTIFICATION_SYSTEM "Copied the cursor over"
fi

if [ "$initial" = "Defaults" ]
then
    echo "User Have Chosen $initial, proceeding..."
    echo "$FULL_PATH"
    skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take elements from.")
    if [ "$skin" = "" ]
    then
        exit 1
    else
        mkdir "$FULL_PATH"/Restore
        mkdir "$FULL_PATH"/Restore/Defaults
        rm -f "$FULL_PATH"/Restore/Defaults/*
        #cd $FULL_PATH
        cd "$FULL_PATH" || exit
        cp -f default-*.png "$FULL_PATH"/Restore/Defaults/
        cp skin.ini "$FULL_PATH"/Restore/Defaults/

        TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
        #echo $TEMP_SKIN_DIR
        cd "$TEMP_SKIN_DIR" || exit
        if [[ $(ls | grep default) ]];
        then
            $NOTIFICATION_SYSTEM "OK!, copying files over..."
            cd "$FULL_PATH" || exit
            rm -f default-*.png
            cd "$TEMP_SKIN_DIR" || exit
            cp -f default-*.png "$FULL_PATH"
        else
            $NOTIFICATION_SYSTEM "No default files in root, searching..."
            cd "$TEMP_SKIN_DIR" || exit
            assetpath=$(find . -name default-1.png | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//')
            #echo $assetpath
            cd "$assetpath" || exit
            cp default-*.png "$FULL_PATH"
            $NOTIFICATION_SYSTEM "OK! Found Assets in:""$assetpath"
        fi

        #grep2=$(cat "$TEMP_SKIN_DIR"/skin.ini | grep -E  Combo[0-9]+ | dmenu -i -p "Hello")
        #tmp_hcoverlap=$(cat "$TEMP_SKIN_DIR"/skin.ini | grep HitCircleOverlap)

        #echo $TEMP_SKIN_DIR
        if cat "$TEMP_SKIN_DIR"/skin.ini | grep -q HitCircleOverlap;
        then
            tmp_hcoverlap_line=$(grep -nr HitCircleOverlap "$TEMP_SKIN_DIR"/skin.ini | cut -f1 -d:)
            hcoverlap_line=$(grep -nr HitCircleOverlap "$SKIN_INI_PATH" | cut -f1 -d:)
            tmp_hcoverlap_fulltext=$(sed ''"$tmp_hcoverlap_line"'!d' "$TEMP_SKIN_DIR"/skin.ini | sed -e 's/^[ \t]*//')
            hcoverlap_fulltext=$(sed ''"$hcoverlap_line"'!d' "$SKIN_INI_PATH")
            echo "$tmp_hcoverlap_fulltext"
            sed -i "s/^.*HitCircleOverlap.*$/$tmp_hcoverlap_fulltext/" "$SKIN_INI_PATH"
            $NOTIFICATION_SYSTEM "From:$hcoverlap_fulltext To:$tmp_hcoverlap_fulltext"
        else
            $NOTIFICATION_SYSTEM "HitCircleOverlap not found"
        fi
    fi


fi