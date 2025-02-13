import React, { useRef, useState } from 'react';
import {
  Animated,
  FlatList,
  Modal,
  NativeModules,
  SafeAreaView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View
} from 'react-native';
import { DiamondGift, HeartGift, StarGift } from '../assets/svg/GiftIcons';

const {GiftManager} = NativeModules;
console.log("🚀 ~ LiveStreamScreen.tsx:16 ~ GiftManager:", GiftManager)

type GiftIcon = typeof HeartGift | typeof StarGift | typeof DiamondGift;

interface Gift {
  id: string;
  name: string;
  price: number;
  category: string;
  icon: GiftIcon;
}

const GIFT_CATEGORIES = [
  {id: '1', name: 'Popular'},
  {id: '2', name: 'Special'},
  {id: '3', name: 'Luxury'},
];

const GIFTS = [
  {
    id: '1',
    name: 'Heart',
    price: 1,
    category: '1',
    icon: HeartGift,
  },
  {
    id: '2',
    name: 'Star',
    price: 5,
    category: '1',
    icon: StarGift,
  },
  {
    id: '3',
    name: 'Diamond',
    price: 100,
    category: '2',
    icon: DiamondGift,
  },
  // Add more gifts as needed
];

const LiveStreamScreen = () => {
  const [showGiftModal, setShowGiftModal] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState('1');
  const [selectedGift, setSelectedGift] = useState<Gift | null>(null);
  const giftAnimation = useRef(new Animated.Value(0)).current;

  const handleDonate = async () => {
    if (!selectedGift) return;

    setShowGiftModal(false);

    if (!GiftManager) {
      console.warn('GiftManager is not available');
      // Fallback to React Native animation only
      Animated.sequence([
        Animated.timing(giftAnimation, {
          toValue: 1,
          duration: 500,
          useNativeDriver: true,
        }),
        Animated.delay(2000),
        Animated.timing(giftAnimation, {
          toValue: 0,
          duration: 500,
          useNativeDriver: true,
        }),
      ]).start(() => {
        setSelectedGift(null);
      });
      return;
    }

    // Show native gift animation
    GiftManager.showGiftAnimation(selectedGift.name, (error: any, result: boolean) => {
      if (error) {
        console.error('Failed to show gift animation:', error);
        return;
      }
      
      // Show React Native animation
      Animated.sequence([
        Animated.timing(giftAnimation, {
          toValue: 1,
          duration: 500,
          useNativeDriver: true,
        }),
        Animated.delay(2000),
        Animated.timing(giftAnimation, {
          toValue: 0,
          duration: 500,
          useNativeDriver: true,
        }),
      ]).start(() => {
        setSelectedGift(null);
      });
    });
  };

  const renderGiftItem = ({item}: {item: Gift}) => (
    <TouchableOpacity
      style={styles.giftItem}
      onPress={() => setSelectedGift(item)}>
      <View style={styles.giftImage}>
        <item.icon />
      </View>
      <Text style={styles.giftName}>{item.name}</Text>
      <Text style={styles.giftPrice}>{item.price} coins</Text>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      {/* Live Stream Content */}
      <View style={styles.streamContainer}>
        <Text style={styles.streamTitle}>Live Stream</Text>

        <TouchableOpacity
          style={styles.giftButton}
          onPress={() => setShowGiftModal(true)}>
          <Text style={styles.giftButtonText}>Send Gift</Text>
        </TouchableOpacity>
      </View>

      {/* Gift Modal */}
      <Modal visible={showGiftModal} transparent animationType="slide">
        <View style={styles.modalContainer}>
          <View style={styles.modalContent}>
            <View style={styles.categories}>
              {GIFT_CATEGORIES.map(category => (
                <TouchableOpacity
                  key={category.id}
                  style={[
                    styles.categoryButton,
                    selectedCategory === category.id && styles.selectedCategory,
                  ]}
                  onPress={() => setSelectedCategory(category.id)}>
                  <Text style={styles.categoryText}>{category.name}</Text>
                </TouchableOpacity>
              ))}
            </View>

            <FlatList
              data={GIFTS.filter(gift => gift.category === selectedCategory)}
              renderItem={renderGiftItem}
              numColumns={4}
              keyExtractor={item => item.id}
            />

            {selectedGift && (
              <View style={styles.previewContainer}>
                <View style={styles.previewImage}>
                  <selectedGift.icon width={100} height={100} />
                </View>
                <TouchableOpacity
                  style={styles.donateButton}
                  onPress={handleDonate}>
                  <Text style={styles.donateButtonText}>
                    Donate {selectedGift.price} coins
                  </Text>
                </TouchableOpacity>
              </View>
            )}

            <TouchableOpacity
              style={styles.closeButton}
              onPress={() => setShowGiftModal(false)}>
              <Text style={styles.closeButtonText}>Close</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>

      {/* Gift Animation */}
      {selectedGift && (
        <Animated.View
          style={[
            styles.giftAnimation,
            {
              opacity: giftAnimation,
              transform: [
                {
                  scale: giftAnimation.interpolate({
                    inputRange: [0, 1],
                    outputRange: [0.5, 1],
                  }),
                },
              ],
            },
          ]}>
          <selectedGift.icon width={150} height={150} />
        </Animated.View>
      )}
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  streamContainer: {
    flex: 1,
    padding: 20,
  },
  streamTitle: {
    color: '#fff',
    fontSize: 20,
    fontWeight: 'bold',
  },
  giftButton: {
    position: 'absolute',
    bottom: 20,
    right: 20,
    backgroundColor: '#1a73e8',
    padding: 10,
    borderRadius: 8,
  },
  giftButtonText: {
    color: '#fff',
    fontSize: 16,
  },
  modalContainer: {
    flex: 1,
    justifyContent: 'flex-end',
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  modalContent: {
    backgroundColor: '#fff',
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    padding: 20,
    height: '60%',
  },
  categories: {
    flexDirection: 'row',
    marginBottom: 20,
  },
  categoryButton: {
    paddingHorizontal: 20,
    paddingVertical: 10,
    marginRight: 10,
    borderRadius: 20,
    backgroundColor: '#f0f0f0',
  },
  selectedCategory: {
    backgroundColor: '#1a73e8',
  },
  categoryText: {
    color: '#000',
    fontSize: 16,
  },
  giftItem: {
    flex: 1,
    alignItems: 'center',
    padding: 10,
  },
  giftImage: {
    width: 60,
    height: 60,
    marginBottom: 5,
  },
  giftName: {
    fontSize: 14,
  },
  giftPrice: {
    fontSize: 12,
    color: '#666',
  },
  previewContainer: {
    alignItems: 'center',
    marginTop: 20,
    paddingTop: 20,
    borderTopWidth: 1,
    borderTopColor: '#eee',
  },
  previewImage: {
    width: 100,
    height: 100,
    marginBottom: 10,
  },
  donateButton: {
    backgroundColor: '#1a73e8',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 8,
  },
  donateButtonText: {
    color: '#fff',
    fontSize: 16,
  },
  closeButton: {
    marginTop: 20,
    alignItems: 'center',
  },
  closeButtonText: {
    color: '#666',
    fontSize: 16,
  },
  giftAnimation: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: [{translateX: -50}, {translateY: -50}],
  },
});

export default LiveStreamScreen;
