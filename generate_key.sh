function keygen() {
    local certs_dir=~/.android-certs
    [ -z "$1" ] || certs_dir=$1
    rm -rf "$certs_dir"
    mkdir -p "$certs_dir"
    local subject
    echo "Sample subject: '/C=AS/ST=Indonesia/L=Jakarta View/O=Android/OU=Android/CN=Android/emailAddress=android@android.com'"
    echo "Now enter subject details for your keys:"
    for entry in C ST L O OU CN emailAddress; do
        echo -n "$entry:"
        read -r val
        subject+="/$entry=$val"
    done

    for cert in bluetooth media networkstack otakey platform releasekey sdk_sandbox shared testkey verity; do \
        ./development/tools/make_key ~/.android-certs/$cert "$subject"; \
    done
}

keygen
