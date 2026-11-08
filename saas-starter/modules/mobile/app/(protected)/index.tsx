import { Text, View } from "react-native";

import { useSession } from "../../lib/auth-context";

export default function Index() {
	const { signOut, session } = useSession();
	return (
		<View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
			<Text>Hello {session?.email}</Text>
			<Text
				onPress={() => {
					// The `app/(app)/_layout.tsx` will redirect to the sign-in screen.
					signOut();
				}}
			>
				Sign Out
			</Text>
		</View>
	);
}
