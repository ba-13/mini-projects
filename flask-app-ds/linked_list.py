class Node:
    def __init__(self, data=None, next_node=None) -> None:
        self.data = data
        self.next_node = next_node


class LinkedList:
    """
    Track the head of LL
    """

    def __init__(self) -> None:
        self.head = None
        self.last_node = None

    def to_list(self):
        l = []
        if self.head is None:
            return l
        node = self.head
        while node:
            l.append(node.data)
            node = node.next_node
        return l

    def insert_at_beginning(self, data):
        if self.head is None:
            # when Linked List is empty, allot end as head
            self.head = Node(data, None)
            self.last_node = self.head
        node = Node(data, self.head)
        self.head = node

    def insert_at_end(self, data):
        if self.head is None:
            self.insert_at_beginning(data)

        if self.last_node is None:
            # * this is for the first time when end isn't alloted,
            # * is never used because we keep track of end already
            # node = self.head
            # while node.next_node:
            #     node = node.next_node
            # node.next_node = Node(data, None)
            # self.last_node = node.next_node
            pass
        else:
            self.last_node.next_node = Node(data, None)
            self.last_node = self.last_node.next_node

    def print_ll(self):
        ll_string = ""
        node = self.head
        if node is None:
            print(None)
        while node:
            ll_string += f" {str(node.data)} ->"
            node = node.next_node
        ll_string += " None"
        print(ll_string)


# ll = LinkedList()
# ll.insert_at_beginning("val1")
# ll.insert_at_beginning("val2")
# ll.insert_at_beginning("val3")
# ll.insert_at_beginning("val4")
# ll.insert_at_beginning("val5")
# ll.insert_at_beginning("val6")
# ll.insert_at_beginning("val7")
# ll.insert_at_end("val_back1")
# ll.insert_at_end("val_back2")
# ll.insert_at_end("val_back3")
# ll.insert_at_end("val_back4")
# ll.print_ll()
