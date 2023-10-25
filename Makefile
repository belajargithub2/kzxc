build_aab:
	echo "Build AAB"
	flutter build appbundle --release

deploy_aab:
	echo "Remove Build Folder"
	rm -rf build

	make build_aab

	echo "Upload to FAD"
	firebase appdistribution:distribute build/app/outputs/bundle/release/app-release.aab --app "1:260814029436:android:9bbfd3b7473a86c1b73ff9" --release-notes-file "release-note.txt" --groups "tester" --token "1//0ge8ZsqlWcv6ZCgYIARAAGBASNwF-L9IrR7vnBn0tdDXWG7ry_jSR640JkGkElDpIOuoV2RfLYrYWSDEyxYT5Q4QdH5aoe15gbcY"
