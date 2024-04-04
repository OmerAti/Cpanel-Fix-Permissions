#! /bin/bash

# Set verbose to null
verbose=""

# Print the help text
helptext () {
    tput bold
    tput setaf 2
    echo "Izinleri Duzelt (fixperms) Betik yardimi:"
    echo "Dosya/dizin izinlerini suPHP ve FastCGI semalarina uyacak sekilde ayarlar"
    echo "KULLANIM: fixperms [secenekler] -a account_name"
    echo "-------"
    echo "Secenekler:"
    echo "-h veya --help: Bu ekrani yazdirin ve cikin"
    echo "--account veya -a: Bir cPanel hesabi belirtin"
    echo "-all: Tum cPanel hesaplarinda calistir"
    echo "-v: Ayrintili cikti"
    tput sgr0
    exit 0
}

fixperms () {

    account=$1
    
    if ! grep $account /var/cpanel/users/*
    then
        tput bold
        tput setaf 1
        echo "Gecersiz cPanel hesabi!"
        tput sgr0
    exit 0
    fi
    
    if [ -z $account ]
    then
        tput bold
        tput setaf 1
        echo "cPanel hesabi olmali!"
        tput sgr0
        helptext
    else

         HOMEDIR=$(egrep "^${account}:" /etc/passwd | cut -d: -f6)

        tput bold
        tput setaf 4
        echo "(fixperms) : $account"
        tput setaf 3
        echo "--------------------------"
        tput setaf 4
        echo "Web sitesi dosyalari duzeltiliyor..."
        tput sgr0

        chown -R $verbose $account:$account $HOMEDIR/public_html

        # Fix individual files in public_html
        find $HOMEDIR/public_html -type d -exec chmod $verbose 755 {} \;
        find $HOMEDIR/public_html -type f | xargs -d$'\n' -r chmod $verbose 644
        find $HOMEDIR/public_html -name '*.cgi' -o -name '*.pl' | xargs -r chmod $verbose 755
        chown $verbose -R $account:$account $HOMEDIR/public_html/.[^.]*
        find $HOMEDIR/* -name .htaccess -exec chown $verbose $account.$account {} \;

        tput bold
        tput setaf 4
        echo "public_html duzeltiliyr..."
        tput sgr0
        chown $verbose $account:nobody $HOMEDIR/public_html
        chmod $verbose 750 $HOMEDIR/public_html

        tput setaf 3
        tput bold
        echo "--------------------------"
        tput setaf 4
        echo "public_html disinda bir docroota sahip tum alan adlarini duzeltme..."
        for SUBDOMAIN in $(grep -i documentroot /var/cpanel/userdata/$account/* | grep -v '.cache\|_SSL' | awk '{print $2}' | grep -v public_html)
        do
            tput bold
            tput setaf 4
            echo "Alt/addon etki alani docrootu icin duzeltme $SUBDOMAIN..."
            tput sgr0
            chown -R $verbose $account:$account $SUBDOMAIN;
            find $SUBDOMAIN -type d -exec chmod $verbose 755 {} \;
            find $SUBDOMAIN -type f | xargs -d$'\n' -r chmod $verbose 644
            find $SUBDOMAIN -name '*.cgi' -o -name '*.pl' | xargs -r chmod $verbose 755
            chown $verbose -R $account:$account $SUBDOMAIN
            chmod $verbose 755 $SUBDOMAIN
            find $SUBDOMAIN -name .htaccess -exec chown $verbose $account.$account {} \;
        done

        # Finished
        tput bold
        tput setaf 3
        echo "Bitti (Kullanici: $account)"
        echo "--------------------------"
        printf "\n\n"
        tput sgr0
    fi

    return 0
}

all () {
    for user in $(cut -d: -f1 /etc/domainusers)
    do
        fixperms $user
    done
}

case "$1" in
    -h) helptext ;;
    --help) helptext ;;
    -v) verbose="-v"

    case "$2" in
        -all) all ;;
        --account) fixperms "$3" ;;
        -a) fixperms "$3" ;;
        *) 
            tput bold
            tput setaf 1
            echo "Bilinmeyen Secenek!"
            helptext
        ;;
    esac
    ;;

    -all) all ;;
    --account) fixperms "$2" ;;
    -a) fixperms "$2" ;;
    *)
        tput bold
        tput setaf 1
        echo "Bilinmeyen Secenek!"
        helptext
    ;;
esac
