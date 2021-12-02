class Node:
    def __init__(self, data=None, next_node=None) -> None:
        self.data = data
        self.next_node = next_node


class Data:
    def __init__(self, key, val) -> None:
        self.key = key
        self.val = val


class HashTable:
    def __init__(self, table_size) -> None:
        self.table_size = table_size
        self.hash_table = [None]*table_size

    def custom_hash(self, key):
        hash_value = 0
        for i in key:
            hash_value += ord(i)
            hash_value = (hash_value * ord(i)) % self.table_size
        return hash_value

    def add_key_value(self, key, val):
        hashed_key = self.custom_hash(key)
        if self.hash_table[hashed_key] is None:
            self.hash_table[hashed_key] = Node(Data(key, val), None)
        else:
            # for adding at beginnning
            tmp = Node(Data(key, val), self.hash_table[hashed_key])
            self.hash_table[hashed_key] = tmp

            # for adding at end
            # node = self.hash_table[hashed_key]
            # while node.next_node:
            #     node = node.next_node
            # node.next_node = Node(Data(key, val), None)

    def get_value(self, key):
        hashed_key = self.custom_hash(key)
        if self.hash_table[hashed_key]:
            node = self.hash_table[hashed_key]
            if node.next_node is None:
                return node.data.val
            while node.next_node:
                if key == node.data.key:
                    return node.data.val
                node = node.next_node
            if key == node.data.key:  # for the last_node
                return node.data.val
        return None

    def print_table(self):
        print("{")
        for i, hashed_pos in enumerate(self.hash_table):
            if hashed_pos:
                llist_string = ""
                node = hashed_pos
                if node.next_node:
                    while node.next_node:
                        llist_string += (
                            str(node.data.key) + " : " +
                            str(node.data.val) + " --> "
                        )
                        node = node.next_node
                    llist_string += (
                        str(node.data.key) + " : " +
                        str(node.data.val) + " --> None"
                    )
                    print(f"    [{i}] {llist_string}")
                else:
                    print(f"    [{i}] {node.data.key} : {node.data.val}")
            else:
                print(f"    [{i}] {hashed_pos}")
        print("}")


# ht = HashTable(4)
# ht.add_key_value("hi", "h3110")
# ht.add_key_value("bye", "|3v/3")
# ht.add_key_value("yeet", "Shamayeeta")
# ht.add_key_value("telemetry", "dunno")
# ht.print_table()
