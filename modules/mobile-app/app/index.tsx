import { useEffect, useState } from "react";
import { Text, View } from "react-native";

export default function Index() {
	const [response, setResponse] = useState<string | undefined>(undefined);

	useEffect(() => {
		fetch(process.env.EXPO_PUBLIC_API_URL!)
			.then((response) => response.text())
			.then((response) => setResponse(JSON.stringify(response, null, 2)));
	}, []);

	return (
		<View
			style={{
				flex: 1,
				justifyContent: "center",
				alignItems: "center",
			}}
		>
			<Text>response: {response ?? "loading..."}</Text>
		</View>
	);
}
