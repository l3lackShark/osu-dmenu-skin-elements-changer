#!/bin/bash

#Put your osu! folder here!
export BASE_DIR="/home/blackshark/drives/ps3drive/osu!"

#Do not touch this unless it doesn't work! (specify your notification manager executable)
export NOTIFICATION_SYSTEM="notify-send"

#Get Current Skin Name
PLAIN_TEXT=$(grep -nrw "Skin =" "$BASE_DIR"/osu\!."$USER".cfg | sed 's/^...........//')
##############################
#Converting Skin Name to Path#
##############################
#Get Full Path to Current Skin
FULL_PATH=$(echo "$BASE_DIR"/Skins/"$PLAIN_TEXT" | tr -d '\r')

#Get Current skin.ini
export SKIN_INI_PATH="$FULL_PATH/skin.ini"






#Initial Question
initial=$(echo -e "Defaults\nFollowPoints\nCursor\nHitSounds\nMisc\nRestore"  | dmenu -i -p "Your current skin is $PLAIN_TEXT, choose the element that you want to modify.")

if [ "$initial" = "Misc"  ]
then
    echo "User Have Chosen" "$initial"
    chosen=$(echo -e "Enable...\nDisable..." | dmenu -i -p "What do you wanna do?")
    if [ "$chosen" = "" ]
    then
        exit 1
    fi



    if [ "$chosen" = "Enable..." ]
    then
        extra=$(echo -e "Combo" | dmenu -i -p "What do you wannna Enable?")
        if [ "$extra" = "Combo" ]
        then
            cd "$FULL_PATH" || exit
            assetpath=$(find . -name combo-0.png | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//')
            if [ "$assetpath" = "" ]
            then
                combowombocheck=$(ls "$FULL_PATH" | grep combo-)
                if [ "$combowombocheck" != "" ]      #This happens if combo is  found in root
                then
                    cd "$FULL_PATH" || exit
                    if [[ $(ls | grep skin) ]];
                    then
                        if cat "$FULL_PATH"/skin.ini | grep -q ComboPrefix;
                        then
                            comboprefix_line=$(grep -nr ComboPrefix "$SKIN_INI_PATH" | cut -f1 -d:)
                            comboprefix_fulltext=$(sed ''"$comboprefix_line"'!d' "$SKIN_INI_PATH")
                            sed -i "s/^.*ComboPrefix.*$/ComboPrefix: combo/" "$SKIN_INI_PATH"
                            $NOTIFICATION_SYSTEM "From:$comboprefix_fulltext To:ComboPrefix: combo"
                        else
                            $NOTIFICATION_SYSTEM "ComboPrefix not found, which means that combo is already enabled!" && exit 1
                        fi
                    fi
                else
                    cd "$FULL_PATH" || exit
                    if [[ $(ls | grep skin) ]];
                    then
                        if cat "$FULL_PATH"/skin.ini | grep -q ComboPrefix;
                        then
                            comboprefix_line=$(grep -nr ComboPrefix "$SKIN_INI_PATH" | cut -f1 -d:)
                            comboprefix_fulltext=$(sed ''"$comboprefix_line"'!d' "$SKIN_INI_PATH")
                            sed -i "s/^.*ComboPrefix.*$/#ComboPrefix enabled/" "$SKIN_INI_PATH"
                            $NOTIFICATION_SYSTEM "From:$comboprefix_fulltext To:#ComboPrefix enabled"
                        else
                            $NOTIFICATION_SYSTEM "ComboPrefix not found, which means that combo is already enabled!" && exit 1
                        fi
                    fi
                fi

            else
                $NOTIFICATION_SYSTEM "We have an asset folder here! (no problem)"
                #$NOTIFICATION_SYSTEM "$assetpath"
                cd "$FULL_PATH"/"$assetpath" || exit
                rootcombo=$(ls "$FULL_PATH" | grep combo-)
                if [ "$rootcombo" = "" ]
                then
                    lastchoice=$(echo -e "Yes\nNo"  | dmenu -i -p "It seems that you had no combo files in root, but you have some in $assetpath, do you want to include them?")

                    if [ "$lastchoice" = "" ]
                    then
                        exit 1
                    fi

                    if [ $lastchoice = "No" ]
                    then
                        cd "$FULL_PATH" || exit
                        if [[ $(ls | grep skin) ]];
                        then
                            if cat "$FULL_PATH"/skin.ini | grep -q ComboPrefix;
                            then
                                comboprefix_line=$(grep -nr ComboPrefix "$SKIN_INI_PATH" | cut -f1 -d:)
                                comboprefix_fulltext=$(sed ''"$comboprefix_line"'!d' "$SKIN_INI_PATH")
                                sed -i "s/^.*ComboPrefix.*$/#ComboPrefix: enabled/" "$SKIN_INI_PATH"
                                $NOTIFICATION_SYSTEM "From:$comboprefix_fulltext To:#ComboPrefix: enabled"
                            else
                                $NOTIFICATION_SYSTEM "ComboPrefix not found, which means that combo is already enabled!" && exit 1
                            fi

                        else
                            $NOTIFICATION_SYSTEM "This should not happen! If this happened, then I live on Mars! (skin.ini nof found)" && exit 1
                        fi
                    fi
                fi


                if [ $lastchoice = "Yes" ]
                then
                    cd "$FULL_PATH"/"$assetpath" || exit  #might be not needed
                    mv -f -- combo-* "$FULL_PATH"
                    cd "$FULL_PATH" || exit
                    if [[ $(ls | grep skin) ]];
                    then
                        if cat "$FULL_PATH"/skin.ini | grep -q ComboPrefix;
                        then
                            comboprefix_line=$(grep -nr ComboPrefix "$SKIN_INI_PATH" | cut -f1 -d:)
                            comboprefix_fulltext=$(sed ''"$comboprefix_line"'!d' "$SKIN_INI_PATH")
                            sed -i "s/^.*ComboPrefix.*$/ComboPrefix: combo/" "$SKIN_INI_PATH"
                            $NOTIFICATION_SYSTEM "From:$comboprefix_fulltext To:ComboPrefix: combo"
                        else
                            $NOTIFICATION_SYSTEM "ComboPrefix not found, which means that combo is already enabled!" && exit 1
                        fi

                    else
                        $NOTIFICATION_SYSTEM "This should not happen! If this happened, then I live on Mars! (skin.ini nof found)" && exit 1
                    fi
                fi

            fi
        fi
    fi
fi

if [ "$chosen" = "Disable..." ]
then
    extra=$(echo -e "Combo" | dmenu -i -p "What do you wannna Disable?")
    if [ "$extra" = "Combo" ]
    then
        mkdir "$FULL_PATH"/Restore
        mkdir "$FULL_PATH"/Restore/Combo/Disabled
        cd "$FULL_PATH" || exit
        cp skin.ini "$FULL_PATH"/Restore/Combo/Disabled



        if cat "$FULL_PATH"/skin.ini | grep -q ComboPrefix;
        then
            comboprefix_line=$(grep -nr ComboPrefix "$SKIN_INI_PATH" | cut -f1 -d:)
            comboprefix_fulltext=$(sed ''"$comboprefix_line"'!d' "$SKIN_INI_PATH")
            sed -i "s/^.*ComboPrefix.*$/ComboPrefix: no/" "$SKIN_INI_PATH"
            $NOTIFICATION_SYSTEM "From:$comboprefix_fulltext To:ComboPrefix: no"
        else
            $NOTIFICATION_SYSTEM "ComboPrefix not found"
            comboprefix_line=$(grep -wnri Fonts "$SKIN_INI_PATH" | cut -f1 -d:)
            match="Fonts]"
            insert='ComboPrefix: no'
            sed -i "s/$match/$match\n$insert/" "$SKIN_INI_PATH"
            $NOTIFICATION_SYSTEM "From:$comboprefix_fulltext To:ComboPrefix: no"
        fi


    fi
fi
if [ "$initial" = "HitSounds"  ]
then
    #Check if current skin has hitsounds.
    followcheck=$(ls "$FULL_PATH" | grep normal)
    if [ "$followcheck" = "" ] #If it doesn't, then...
    then
        skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take HitSounds from.")
        if [ "$skin" = "" ]
        then
            { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
        fi
        $NOTIFICATION_SYSTEM "No hitsounds in current skin, just copying new ones over"
        TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
        cd "$TEMP_SKIN_DIR" || { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
        assetpath=$(find "$TEMP_SKIN_DIR" -name normal-hitnormal.wav | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//') #TODO FIX potential not found
        if [ "$assetpath" = "" ]
        then
            followcheck=$(ls "$TEMP_SKIN_DIR" | grep normal)
            if [ "$followcheck"  = "" ]
            then { $NOTIFICATION_SYSTEM "No followpoints found in that skin!"; exit 1; }   #TODO Fix Duplicate function
            fi
        fi
        cd "$TEMP_SKIN_DIR" || exit

        mkdir "$FULL_PATH"/Restore
        mkdir "$FULL_PATH"/Restore/HitSounds


        rm -f "$FULL_PATH"/Restore/HitSounds/*
        cd "$TEMP_SKIN_DIR" || exit
        if [[ $(ls | grep normal) ]];
        then
            echo "OK!, copying files over..."
            cp -f normal* "$FULL_PATH"
            cp -f soft* "$FULL_PATH" 
            $NOTIFICATION_SYSTEM "Finished copying!"
        else
            { $NOTIFICATION_SYSTEM "No hitsounds found in that skin!"; exit 1; }

        fi

    else


        skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take HitSounds from.")
        TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
        cd "$TEMP_SKIN_DIR" || { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }

        mkdir "$FULL_PATH"/Restore
        mkdir "$FULL_PATH"/Restore/HitSounds


        rm -f "$FULL_PATH"/Restore/HitSounds/*
        cd "$FULL_PATH" || exit
        cp -f normal* "$FULL_PATH"/Restore/HitSounds
        cp -f soft* "$FULL_PATH"/Restore/HitSounds
        cp -f drum* "$FULL_PATH"/Restore/HitSounds
        TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
        cd "$TEMP_SKIN_DIR" || exit
        if [[ $(ls | grep normal) ]];
        then
            echo "OK!, copying files over..."
            cd "$FULL_PATH" || exit
            rm -f normal* 
            rm -f soft* 
            rm -f drum* 
            cd "$TEMP_SKIN_DIR" || exit
            cp -f normal* "$FULL_PATH" 
            cp -f drum* "$FULL_PATH" 
            cp -f soft* "$FULL_PATH" 
            $NOTIFICATION_SYSTEM "Finished copying!"
        else
            { $NOTIFICATION_SYSTEM "No hitsounds found in that skin!"; exit 1; }
        fi
    fi
fi

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
            skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take FollowPoints from.")
            if [ "$skin" = "" ]
            then
                { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
            fi
            $NOTIFICATION_SYSTEM "No followpoints in current skin, just copying new ones over"
            TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
            cd "$TEMP_SKIN_DIR" || { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
            assetpath=$(find "$TEMP_SKIN_DIR" -name followpoint.png | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//') #TODO FIX potential not found
            if [ "$assetpath" = "" ]
            then
                followcheck=$(ls "$TEMP_SKIN_DIR" | grep followpoint)
                if [ "$followcheck"  = "" ]
                then { $NOTIFICATION_SYSTEM "No followpoints found in that skin!"; exit 1; }   #TODO Fix Duplicate function
                fi
            fi
            cd "$TEMP_SKIN_DIR" || exit

            mkdir "$FULL_PATH"/Restore
            mkdir "$FULL_PATH"/Restore/FollowPoints


            rm -f "$FULL_PATH"/Restore/FollowPoints/* && cp skin.ini "$FULL_PATH"/Restore/FollowPoints
            cd "$TEMP_SKIN_DIR" || exit
            if [[ $(ls | grep followpoint) ]];
            then
                echo "OK!, copying files over..."
                cp -f followpoint*.png "$FULL_PATH"
                $NOTIFICATION_SYSTEM "Finished copying!"
            else
                { $NOTIFICATION_SYSTEM "No followpoints found in that skin!"; exit 1; }

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
            cd "$TEMP_SKIN_DIR" || exit
            if [[ $(ls | grep followpoint) ]];
            then
                echo "OK!, copying files over..."
                cd "$FULL_PATH" || exit
                rm -f followpoint*.png
                cd "$TEMP_SKIN_DIR" || exit
                cp -f followpoint*.png "$FULL_PATH"
                $NOTIFICATION_SYSTEM "Finished copying!"
            else
                { $NOTIFICATION_SYSTEM "No followpoints found in that skin!"; exit 1; }
            fi
        fi
    fi
    if [ "$chosen" = "Yes" ]
    then
        #Check if current skin has followpoints.
        followcheck=$(ls "$FULL_PATH" | grep followpoint)
        if [ "$followcheck" = "" ] #If it doesn't, then...
        then
            skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take FollowPoints from.")
            if [ "$skin" = "" ]
            then
                { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
            fi
            $NOTIFICATION_SYSTEM "No followpoints in current directory, just copying new ones over"
            TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
            cd "$TEMP_SKIN_DIR" || { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
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
                echo "OK!, copying files over..."
                cp -f followpoint*.png "$FULL_PATH"
                $NOTIFICATION_SYSTEM "Finished copying!"
            else
                { $NOTIFICATION_SYSTEM "No followpoints found in that skin!"; exit 1; }

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
            cd "$TEMP_SKIN_DIR" || exit
            if [[ $(ls | grep followpoint) ]];
            then
                echo "OK!, copying files over..."
                cd "$FULL_PATH" || exit
                rm -f followpoint*.png
                cd "$TEMP_SKIN_DIR" || exit
                cp -f followpoint*.png "$FULL_PATH"
                $NOTIFICATION_SYSTEM "Finished copying!"
            else
                { $NOTIFICATION_SYSTEM "No followpoints found in that skin!"; exit 1; }
            fi
        fi
        if cat "$TEMP_SKIN_DIR"/skin.ini | grep -q AnimationFramerate; #TODO "//" Handling
        then
            tmp_follow_line=$(grep -nr AnimationFramerate "$TEMP_SKIN_DIR"/skin.ini | cut -f1 -d:)
            follow_line=$(grep -nr AnimationFramerate "$SKIN_INI_PATH" | cut -f1 -d:)
            tmp_follow_fulltext=$(sed ''"$tmp_follow_line"'!d' "$TEMP_SKIN_DIR"/skin.ini | sed -e 's/^[ \t]*//')
            follow_fulltext=$(sed ''"$follow_line"'!d' "$SKIN_INI_PATH")
            sed -i "s/^AnimationFramerate.*$/$tmp_follow_fulltext/" "$SKIN_INI_PATH"
            $NOTIFICATION_SYSTEM "From:$follow_fulltext To:$tmp_follow_fulltext"
        else
            $NOTIFICATION_SYSTEM "AnimationFramerate not found, commenting previous value..."
            #tmp_null_framerate=$("//AnimationFramerate: 30")
            #sed 's/.*AnimationFramerate/'#&/' $SKIN_INI_PATH
            sed -i 's/^AnimationFramerate/#&/' "$SKIN_INI_PATH"


        fi
    fi
fi

if [ "$initial" = "Restore" ] #TODO Exception Handling
then
    echo "User Have Chosen" "$initial"
    chosen=$(echo -e "Defaults\nCursor\nFollowPoints\nHitSounds" | dmenu -i -p "What do you want to restore?")

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
    if [ "$chosen" = "HitSounds" ]
    then
        cd "$FULL_PATH" || exit
        rm -f normal*
        rm -f soft*
        rm -f drum*
        cd "$FULL_PATH"/Restore/HitSounds || exit
        cp -f normal* "$FULL_PATH"
        cp -f drum* "$FULL_PATH"
        cp -f soft* "$FULL_PATH"
        $NOTIFICATION_SYSTEM "Restored the HitSounds!"
    fi


fi

if [ "$initial" = "Cursor" ]
then
    echo "User Have Chosen $initial, proceeding..."
    followcheck=$(ls "$FULL_PATH" | grep cursor)
    skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take cursor from.")
    if [ "$skin" = "" ]
    then
        { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
    fi
    TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
    cd "$TEMP_SKIN_DIR" || { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
    if [ ! -f "$TEMP_SKIN_DIR"/cursor.png ] && [ ! -f "$TEMP_SKIN_DIR"/cursor@2x.png ] && [ ! -f "$TEMP_SKIN_DIR"/cursortrail.png ] && [ ! -f "$TEMP_SKIN_DIR"/cursortrail@2x.png ]
    then
        $NOTIFICATION_SYSTEM "There is no cursor in this skin!"
    else

        mkdir "$FULL_PATH"/Restore
        mkdir "$FULL_PATH"/Restore/Cursors
        cd "$FULL_PATH"/Restore/Cursors || exit
        rm -f cursor*.png
        cd "$FULL_PATH" && cp -f cursor*.png "$FULL_PATH"/Restore/Cursors
        rm -f cursor*.png
        cd "$TEMP_SKIN_DIR" || exit
        cp cursor*.png "$FULL_PATH/"
        $NOTIFICATION_SYSTEM "Copied the cursor over"

    fi
fi
if [ "$initial" = "Defaults" ]
then
    echo "User Have Chosen $initial, proceeding..."
    skin=$(ls "$BASE_DIR"/Skins | dmenu -l 30 -i -p "Select the skin that you want to take elements from.")
    if [ "$skin" = "" ]
    then
        { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
    fi
    TEMP_SKIN_DIR=$(echo "$BASE_DIR/Skins/$skin" | tr -d '\r')
    cd "$TEMP_SKIN_DIR" || { $NOTIFICATION_SYSTEM "This skin directory doesn't exist!"; exit 1; }
    mkdir "$FULL_PATH"/Restore
    mkdir "$FULL_PATH"/Restore/Defaults
    rm -f "$FULL_PATH"/Restore/Defaults/*
    cd "$FULL_PATH" || exit
    cp -f default-*.png "$FULL_PATH"/Restore/Defaults/
    cp skin.ini "$FULL_PATH"/Restore/Defaults/
    cd "$TEMP_SKIN_DIR" || exit
    if [[ $(ls | grep default) ]];
    then
        echo "OK!, copying files over..."
        cd "$FULL_PATH" || exit
        rm -f default-*.png
        cd "$TEMP_SKIN_DIR" || exit
        cp -f default-*.png "$FULL_PATH"
        $NOTIFICATION_SYSTEM "Finished copying!"
    else
        $NOTIFICATION_SYSTEM "No default files in root, searching..."
        cd "$TEMP_SKIN_DIR" || exit
        assetpath=$(find . -name default-1.png | sed 's%/[^/]*$%/%' | sed 's/^.\{2\}//')
        cd "$assetpath" || exit
        cp default-*.png "$FULL_PATH"
        $NOTIFICATION_SYSTEM "OK! Found Assets in:""$assetpath"
    fi

    #grep2=$(cat "$TEMP_SKIN_DIR"/skin.ini | grep -E  Combo[0-9]+ | dmenu -i -p "Hello")
    #tmp_hcoverlap=$(cat "$TEMP_SKIN_DIR"/skin.ini | grep HitCircleOverlap)

    if cat "$TEMP_SKIN_DIR"/skin.ini | grep -q HitCircleOverlap;
    then
        tmp_hcoverlap_line=$(grep -nr HitCircleOverlap "$TEMP_SKIN_DIR"/skin.ini | cut -f1 -d:)
        hcoverlap_line=$(grep -nr HitCircleOverlap "$SKIN_INI_PATH" | cut -f1 -d:)
        tmp_hcoverlap_fulltext=$(sed ''"$tmp_hcoverlap_line"'!d' "$TEMP_SKIN_DIR"/skin.ini | sed -e 's/^[ \t]*//')
        hcoverlap_fulltext=$(sed ''"$hcoverlap_line"'!d' "$SKIN_INI_PATH")
        sed -i "s/^.*HitCircleOverlap.*$/$tmp_hcoverlap_fulltext/" "$SKIN_INI_PATH"
        $NOTIFICATION_SYSTEM "From:$hcoverlap_fulltext To:$tmp_hcoverlap_fulltext"
    else
        $NOTIFICATION_SYSTEM "HitCircleOverlap not found"
    fi
fi
